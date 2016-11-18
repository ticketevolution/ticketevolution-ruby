require 'spec_helper'

describe TicketEvolution::ApiError do
  let(:klass) { TicketEvolution::ApiError }
  let(:response) { Fake.error_response }
  let(:instance) { klass.new(response) }

  subject { instance }

  it(:code) { should == response.response_code }
  it(:message) { should == response.server_message }
  it(:error) { should == response.body['error'] }
  it(:extra_parameter) { should == response.body['extra_parameter'] }

  it "should inherit from TicketEvolution::Model" do
    klass.ancestors.should include TicketEvolution::Model
  end

  it { should be_frozen }

  it "should not raise if a missing method is called" do
    expect {
      subject.not_a_method
    }.to_not raise_error
  end
end
