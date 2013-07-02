require 'spec_helper'
require 'logger'

describe TicketEvolution::Connection do
  let(:klass) { TicketEvolution::Connection }
  let(:default_options) do
    HashWithIndifferentAccess.new({
      :version => klass.oldest_version_in_service,
      :mode => :sandbox,
      :ssl_verify => true,
      :logger => nil
    })
  end
  let(:basic_options) do
    {
      :token => Fake.token,
      :secret => Fake.secret
    }
  end
  let(:valid_options) { default_options.merge(basic_options) }

  subject { klass }

  its(:ancestors) { should include TicketEvolution::Base }

  describe ".default_options" do
    subject { klass.default_options }

    it { should == default_options }
  end

  describe ".expected_options" do
    subject { klass.expected_options }

    it { should =~ valid_options.keys }
  end

  describe ".oldest_version_in_service" do
    subject { klass.oldest_version_in_service }

    it { should be_a Fixnum }
  end

  describe ".adapter" do
    subject { klass.adapter }

    it "should be an available Faraday adapter" do
      Faraday::Adapter.constants.collect{|a| a.to_s.underscore.to_sym}.should include subject
    end

    it "should be settable at a class level" do
      klass.should respond_to :adapter=
    end
  end

  describe "#initialize" do
    let(:expected_options) { klass.expected_options }

    context "with valid options" do
      it "should copy to options passed to the default options" do
        klass.new(basic_options).instance_eval {
          @config
        }.should == valid_options
      end
    end

    context "with ssl_verify" do
      context "if passed" do
        let(:options) { valid_options.merge(:ssl_verify => false) }

        it "sets the request object to ssl verify false" do
          connection = klass.new(options)
          request = connection.build_request(:GET, '/')
          request.ssl[:verify].should be_false
        end
      end

      context "if not passed" do
        let(:options) {
          opts = valid_options.clone
          opts.delete(:ssl_verify)
          opts
        }
        it "sets the request object to ssl verify true" do
          connection = klass.new(options)
          request = connection.build_request(:GET, '/')
          request.ssl[:verify].should be_true
        end
      end
    end

    context "without any options" do
      it "should raise an error notifying the user of the missing options" do
        message = "Missing: #{(expected_options - default_options.keys).join(', ')}"
        expect {
          klass.new
        }.to raise_error TicketEvolution::InvalidConfiguration, message
      end
    end

    context "with invalid options" do
      it "should raise an error if the token is not formatted correctly" do
        expect {
          klass.new(valid_options.merge({:token => "invalid"}))
        }.to raise_error TicketEvolution::InvalidConfiguration, "Invalid Token Format"
      end

      it "should raise an error if the token is not formatted correctly" do
        expect {
          klass.new(valid_options.merge({:secret => "invalid"}))
        }.to raise_error TicketEvolution::InvalidConfiguration, "Invalid Secret Format"
      end

      it "should raise an error if attempting to use an expired version" do
        oldest_version = klass.oldest_version_in_service - 1
        expect {
          klass.new(valid_options.merge({:version => oldest_version}))
        }.to raise_error TicketEvolution::InvalidConfiguration, "Please Use API Version #{klass.oldest_version_in_service} or Above"
      end

      it "should not error if bad options are passed in" do
        expect {
          klass.new(valid_options.merge(:invalid => :option))
        }.to_not raise_error
      end
    end

    context "with logger object is set" do
      use_vcr_cassette "core/connection", :record => :new_episodes

      let(:target) { StringIO.new }
      let(:logger) { Logger.new(target) }
      let(:instance) { klass.new(valid_options.merge({:logger => logger})) }

      it "should add the requests and responses to the object" do
        expect {
          req = instance.build_request(:GET, '/', {})
          req.get
        }.to change(target, :size).by_at_least(1)
      end
    end
  end

  describe ".subdomain" do
    subject { klass.subdomain }

    after do
      klass.subdomain = TicketEvolution::Connection::DEFAULT_SUBDOMAIN
    end

    it { should == "api" }

    it "should allow modification of the subdomain" do
      klass.subdomain = 'asdf'
      klass.subdomain.should == 'asdf'
    end

    it "should use the subdomain in the URL" do
      klass.subdomain = 'new-api'
      c = klass.new(basic_options)

      c.url.should match(/new-api/)
    end
  end

  describe ".url_base" do
    subject { klass.url_base }

    it { should == "ticketevolution.com" }
  end

  describe ".protocol" do
    subject { klass.protocol }

    it { should == "https" }
  end

  describe "#url" do
    context "mode is blank" do
      subject { klass.new(valid_options.merge({:mode => nil}))}

      its(:url) { should == "https://api.ticketevolution.com" }
    end

    context "production" do
      subject { klass.new(valid_options.merge({:mode => :production}))}

      its(:url) { should == "https://api.ticketevolution.com" }
    end

    context "sandbox" do
      subject { klass.new(valid_options) }

      its(:url) { should == "https://api.sandbox.ticketevolution.com" }
    end
  end

  describe "#uri" do
    let(:path) { '/test' }

    context "api version 8" do
      subject { klass.new(valid_options) }

      it "should not include the version" do
        subject.uri(path).should == "#{subject.url}#{path}"
      end
    end

    context "api version 9 or above" do
      subject { klass.new(valid_options.merge({:version => 9})) }

      it "should include the version" do
        subject.uri(path).should == "#{subject.url}/v9#{path}"
      end
    end
  end

  describe "#sign" do
    let(:path) { "#{connection.url}/test" }

    describe "with a port in the url_base" do
      let(:connection) { klass.new(valid_options.merge({:secret => "/3uZ9bXNe/6rxEBmlGLvoRXrcSzRDMfyJSewhlrc"})) }

      before { klass.url_base = "ticketevolution.com:3000" }

      it "should sign a get request" do
        connection.sign(:GET, path).should == "1Ra2c8cbuw1G5Pw8BWaowDlMcxwMte8y/sL+vW2H4mY="
      end

      after { klass.url_base = "ticketevolution.com" }
    end

    describe "without params" do
      let(:connection) { klass.new(valid_options.merge({:secret => "/3uZ9bXNe/6rxEBmlGLvoRXrcSzRDMfyJSewhlrc"})) }

      it "should sign a get request" do
        connection.sign(:GET, path).should == "1Ra2c8cbuw1G5Pw8BWaowDlMcxwMte8y/sL+vW2H4mY="
      end

      it "should sign a post request" do
        connection.sign(:POST, path).should == "pXqUawURysCxiIvPXCgTaQ1k5Nue0bAVHIyhrxJRmI0="
      end

      it "should sign a put request" do
        connection.sign(:PUT, path).should == "+INyuqXHZv3+ybyGM/mQIJVJ6RslR/xUAmcauZnHWBo="
      end

      it "should sign a delete request" do
        connection.sign(:DELETE, path).should == "Mwr4Z+hveuo8ITaYwaRQ/QdxYotpw97ZH1JfJmblVQY="
      end
    end

    describe "with params" do
      let(:params) do
        if RUBY_VERSION =~ /^1\.9/
          {
            :one => 1,
            :two => "two",
            :three => :three
          }
        else
          p = ActiveSupport::OrderedHash.new
          p[:one] = 1
          p[:two] = "two"
          p[:three] = "three"
          p
        end
      end
      let(:connection) { klass.new(valid_options.merge({:secret => "/3uZ9bXNe/6rxEBmlGLvoRXrcSzRDMfyJSewhlrc"})) }

      it "should sign a get request" do
        connection.sign(:GET, path, params).should == "8eaaqg6d4DJ2SEWkCvkdhc05dITmpNbUrcbN75UBGMA="
      end

      it "should sign a post request" do
        connection.sign(:POST, path, params).should == "6PMaU8JQ5kH4PZLl8agJrZRZqnn65UGcCUA80E2dTDg="
      end

      it "should sign a put request" do
        connection.sign(:PUT, path, params).should == "JEwlN3cuRXnb6rQlaorVYtlbGbBQRXs792YGQaH5BoM="
      end

      it "should sign a delete request" do
        connection.sign(:DELETE, path, params).should == "aHXaOzCmuVttO2qSnaH5Ku4SN2q/ukoxz2FIbCRWmeY="
      end
    end
  end

  describe "#build_request" do
    let(:req_options) { valid_options.merge(:secret => "/3uZ9bXNe/6rxEBmlGLvoRXrcSzRDMfyJSewhlrc") }
    let(:params) do
      {
        :one => 1,
        :two => "two",
        :three => :three
      }
    end
    let(:url) { "https://api.sandbox.ticketevolution.com/test?one=1&three=three&two=two" }

    subject { klass.new(valid_options).build_request(:GET, '/test', params) }

    it { should be_a Faraday::Connection }

    context "api version 8" do
      let(:headers) do
        {
          "Accept" => "application/vnd.ticketevolution.api+json; version=#{valid_options[:version]}",
          "X-Signature" => "8eaaqg6d4DJ2SEWkCvkdhc05dITmpNbUrcbN75UBGMA=",
          "X-Token" => valid_options[:token],
          "Content-Type" => "application/json"

        }
      end
      subject { klass.new(req_options).build_request(:GET, '/test', params) }

      its(:headers) { should == headers }
    end

    context "api version 9 or above" do
      let(:headers) do
        {
          "X-Signature" => "YbwEmJL9P0hvpplEr2q2iL4Mpz+KevHUOjzgYh0ewh4=",
          "X-Token" => valid_options[:token],
          "Content-Type" => "application/json"
        }
      end
      subject { klass.new(req_options.merge(:version => 9)).build_request(:GET, '/test', params) }

      its(:headers) { should == headers }
    end
  end
end
