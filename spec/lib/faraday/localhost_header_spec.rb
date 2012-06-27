require 'rspec/autorun'
require 'faraday/localhost_header'
require 'uri'
require 'ostruct'

describe FaradayLocalhostHeader do
  let(:url) { URI("http://#{hostname}:8080/hello") }

  let(:env) do
    { :url => url, :request_headers => {} }
  end

  let(:app) do
    described_class.new lambda {|env| env }
  end

  subject do
    result_env = app.call env
    OpenStruct.new :url => result_env[:url].to_s,
      :host_header => result_env[:request_headers]['Host']
  end

  context "normal domain" do
    let(:hostname)    { 'example.com' }
    its(:url)         { should eq('http://example.com:8080/hello') }
    its(:host_header) { should be_nil }
  end

  context "using lvh.me" do
    let(:hostname)    { 'lvh.me' }
    its(:url)         { should eq('http://127.0.0.1:8080/hello') }
    its(:host_header) { should eq('lvh.me') }
  end

  context "using lvh.me with subdomains" do
    let(:hostname)    { 'api.staging.lvh.me' }
    its(:url)         { should eq('http://127.0.0.1:8080/hello') }
    its(:host_header) { should eq('api.staging.lvh.me') }
  end

  context "regular xip.io" do
    let(:hostname)    { 'xip.io' }
    its(:url)         { should eq('http://xip.io:8080/hello') }
    its(:host_header) { should be_nil }
  end

  context "xip.io with ip" do
    let(:hostname)    { '10.0.0.1.xip.io' }
    its(:url)         { should eq('http://10.0.0.1:8080/hello') }
    its(:host_header) { should eq('10.0.0.1.xip.io') }
  end

  context "xip.io with subdomain" do
    let(:hostname)    { 'api.10.0.0.1.xip.io' }
    its(:url)         { should eq('http://10.0.0.1:8080/hello') }
    its(:host_header) { should eq('api.10.0.0.1.xip.io') }
  end
end
