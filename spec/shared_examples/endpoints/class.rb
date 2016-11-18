require 'spec_helper'

shared_examples_for "a ticket_evolution endpoint class" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:sample_parent) { TicketEvolution::Samples.new }
  let(:faraday) { double(:faraday, :get => nil, :post => nil, :put => nil, :delete => nil) }
  let(:instance) { klass.new({:parent => connection}) }
  let(:path) { '/search' }
  let(:full_path) { "#{instance.base_path}#{path}" }

  describe "#initialize" do
    context "with an options hash for it's first parameter" do
      it "should create accessors for each key value pair" do
        instance = klass.new({
          :parent => connection,
          :test => :one,
          :testing => "two",
          :number => 3,
          :hsh => {}
        })
        instance.parent.should == connection
        instance.test.should == :one
        instance.testing.should == "two"
        instance.number.should == 3
        instance.hsh.should == {}
      end

      context "with a parent k/v pair" do
        context "that does not inherit from TicketEvolution::Base" do
          it "should raise an EndpointConfigurationError" do
            message = "#{klass} instances require a parent which inherits from TicketEvolution::Base"
            expect {
              klass.new({:parent => Object.new})
            }.to raise_error TicketEvolution::EndpointConfigurationError, message
          end
        end

        context "that does inherit from TicketEvolution::Base" do
          context "and is a TicketEvolution::Connection object" do
            let(:instance) { klass.new({:parent => connection}) }

            it "should not raise" do
              expect { instance }.to_not raise_error
            end

            it "should be capable of being marshaled" do
              expect {
                Marshal.dump(instance)
              }.to_not raise_error
            end
          end

          context "and has a TicketEvolution::Connection object in it's parent chain" do
            let(:sample_chain) do
              TicketEvolution::Endpoint.new({
                :parent => TicketEvolution::Endpoint.new({
                  :parent => connection
                })
              })
            end

            it "should not raise" do
              expect { klass.new({:parent => klass.new({:parent => sample_chain})}) }.to_not raise_error
            end
          end

          context "and does not have a TicketEvolution::Connection object in it's parent chain" do
            it "should raise an EndpointConfigurationError" do
              message = "The parent passed in the options hash must be a TicketEvolution::Connection object or have one in it's parent chain"
              expect {
                klass.new({:parent => sample_parent})
              }.to raise_error TicketEvolution::EndpointConfigurationError, message
            end
          end
        end
      end

      context "without a parent k/v pair" do
        it "should raise an EndpointConfigurationError" do
          message = "The options hash must include a parent key / value pair"
          expect {
            klass.new({})
          }.to raise_error TicketEvolution::EndpointConfigurationError, message
        end
      end
    end

    context "with no first parameter or a non hash object" do
      it "should raise an EndpointConfigurationError" do
        message = "#{klass} instances require a hash as their first parameter"
        expect { klass.new }.to raise_error TicketEvolution::EndpointConfigurationError, message
      end
    end
  end

  describe "#base_path" do
    let(:endpoint_name) { klass.name.demodulize.underscore }

    context "when #parent is a TicketEvolution::Connection object" do
      let(:path) { "/#{endpoint_name}" }

      it "should be generated based on its class name" do
        klass.new({:parent => connection}).base_path.should == path
      end
    end

    context "when #parent is not a TicketEvolution::Connection object" do
      let(:instance) { klass.new({:parent => connection, :id => 1}) }
      let(:path) { "/#{instance.endpoint_name}/#{instance.id}/#{endpoint_name}" }
      it "should be generated based on its class name and the class names of its parents" do
        klass.new({:parent => instance}).base_path.should == path
      end
    end
  end

  describe "#connection" do
    context "the connection object is the parent" do
      subject { klass.new({:parent => connection}) }

      it(:connection) { should == connection }
    end

    context "the connection object is not the parent" do
      subject { klass.new({:parent => TicketEvolution::Endpoint.new({:parent => connection})}) }

      it(:connection) { should == connection }
    end
  end

  describe "#build_request" do
    context "which is valid" do
      context "with params" do
        let(:params) do
          {
            :page => 1,
            :per_page => 10,
            :name => "test"
          }
        end

        [:GET, :POST, :PUT, :DELETE].each do |method|
          it "should accept an http '#{method}' method, a url path for the call and a list of parameters as a hash and pass them to connection" do
            connection.should_receive(:build_request).with(method, full_path, params).and_return(faraday)

            instance.build_request(method, path, params)
          end
        end
      end

      context "without params" do
        [:GET, :POST, :PUT, :DELETE].each do |method|
          it "should accept an http '#{method}' method and a url path for the call and pass them to connection" do
            connection.should_receive(:build_request).with(method, full_path, nil).and_return(faraday)

            instance.build_request(method, path)
          end
        end
      end

      context "with build_path set to false" do
        [:GET, :POST, :PUT, :DELETE].each do |method|
          it "should not include the base_path when it calls connection#build_request" do
            connection.should_receive(:build_request).with(method, path, nil).and_return(faraday)

            instance.build_request(method, path, nil, false)
          end
        end
      end
    end

    context "given an invalid http method" do
      it "should raise a EndpointConfigurationError" do
        message = "#{klass.to_s}#request requires it's first parameter to be a valid HTTP method"

        expect { instance.request('BAD', path) }.to raise_error TicketEvolution::EndpointConfigurationError, message
      end
    end
  end

  describe "#request" do
    subject { instance.request method, full_path }
    let(:method) { :GET }
    let(:response) { Fake.response }
    let(:handler) { Fake.send(:method, :response_handler) }

    it "calls http on the return faraday object with the method for the request" do
      connection.should_receive(:build_request).and_return(faraday)
      instance.should_receive(:naturalize_response).and_return(response)

      instance.request(method, path, nil, &handler).should == Fake.response_handler(true)
    end

    context "when there is an error from the api" do
      let(:response) { Fake.error_response }

      before do
        connection.should_receive(:build_request).and_return(faraday)
        instance.should_receive(:naturalize_response).and_return(response)
      end

      it "should return an instance of TicketEvolution::ApiError" do
        subject.should be_a TicketEvolution::ApiError
      end
    end

    context "when successful" do
      let(:response) { Fake.response }

      before do
        connection.should_receive(:build_request).and_return(faraday)
        instance.should_receive(:naturalize_response).and_return(response)
      end

      it "should pass the response object to #build_object" do
        instance.request(method, path, nil, &handler).should == Fake.response_handler(true)
      end
    end

    context "when there is a redirect response" do
      let(:response) { Fake.redirect_response }
      let(:faraday_response) { double(:dummy_response) }
      let(:redirect_path) { '/something_else/1'}
      let(:second_faraday) { double(:faraday, :get => nil, :post => nil, :put => nil, :delete => nil) }
      let(:second_response) { Fake.response }

      before do
        connection.should_receive(:build_request).with(:GET, instance.base_path, nil).and_return(faraday)
        instance.should_receive(:naturalize_response).and_return(response)
        instance.connection.should_receive(:build_request).with(:GET, redirect_path, nil).and_return(second_faraday)
        instance.should_receive(:naturalize_response).and_return(second_response)
      end

      it "should follow the redirect path" do
        instance.request(:GET, nil, nil, &handler)
      end
    end
  end

  describe "#naturalize_response" do
    let(:path) { '/list' }
    let(:instance) { klass.new({:parent => connection}) }
    let(:full_path) { "#{instance.base_path}#{path}" }
    let(:response_code) { 200 }
    let(:response) { mock(:response, {
      :headers => {},
      :status => response_code,
      :body => body_str
    }) }

    context "with a valid body" do
      subject { instance.naturalize_response response }
      let(:body_str) { "{\"test\": \"hello\"}" }

      it(:header) { should == response.headers }
      it(:body) { should == MultiJson.decode(response.body).merge({:connection => connection}) }

      TicketEvolution::Endpoint::RequestHandler::CODES.each do |code, value|
        context "with response code #{code}" do
          let(:response_code) { code }

          it(:response_code) { should == code }
          it(:server_message) { should == value.last }
        end
      end

      context "with a missing response code" do
        let(:response_code) { 900 }

        it(:response_code) { should == 900 }
        it(:server_message) { should == "Unknown Error" }
      end
    end
  end

  context "#endpoint_name" do
    it "returns the demodulized version of the endpoint name" do
      instance.endpoint_name.should == klass.name.demodulize.underscore
    end
  end

  context "#singular_class" do
    it "returns the singular version of an Endpoint class" do
      instance.singular_class.should == single_klass
    end
  end
end
