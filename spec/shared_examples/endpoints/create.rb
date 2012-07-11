require 'spec_helper'

shared_examples_for "a create endpoint" do
  let(:connection) { TicketEvolution::Connection.new({:token => Fake.token, :secret => Fake.secret}) }
  let(:builder_klass) { "TicketEvolution::#{klass.to_s.split('::').last.singularize.camelize}".constantize }
  let(:instance) { klass.new({:parent => connection}) }

  describe "#create" do
    context "with params" do
      let(:params) { {:name => "Bob"} }

      it "should pass call request as a POST, passing params" do
        instance.should_receive(:request).with(:POST, nil, instance.endpoint_name.to_sym => [params])

        instance.create(params)
      end
    end

    context "without params" do
      it "should pass call request as a POST, without params" do
        instance.should_receive(:request).with(:POST, nil, nil)

        instance.create
      end
    end

		context "when passed an array" do
			let(:params) { [{:name => "item1"}, {:name => "item2"}] }
			
			it "should pass call request as a POST, passing params" do
        instance.should_receive(:request).with(:POST, nil, instance.endpoint_name.to_sym => params)

        instance.create(params)				
			end
		end

    context "when passed a block" do
      let(:block) { Fake.response_alt }
      let(:response) { Fake.create_response }

      it "should process the response through the block" do
        instance.should_receive(:naturalize_response).and_return(response)

        instance.create({}, &block).should == block.call(response)
      end
    end
  end

  describe "#build_for_create" do
    context "for a single entry" do
      let(:response) { Fake.create_response instance.endpoint_name, connection }
      let(:entry) { double(:entry) }

      it "should invoke an instance of its builder class" do
        builder_klass.should_receive(:new).with(response.body[instance.endpoint_name].first.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => connection
        })).and_return(entry)

        instance.build_for_create(response).should == entry
      end
    end

    context "for multiple entries" do
      let(:responses) { Fake.create_response instance.endpoint_name, connection, 2 }
      let(:entry) { double(:entry) }

      it "should invoke an instance of its builder class" do
        responses.body[instance.endpoint_name].each do |body|
          builder_klass.should_receive(:new).with(body.merge({
            :status_code => responses.response_code,
            :server_message => responses.server_message,
            :connection => connection
          })).and_return(entry)
        end

        instance.build_for_create(responses).entries.should == [entry, entry]
      end
    end
  end
end
