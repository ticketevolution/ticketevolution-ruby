require 'spec_helper'

describe TicketEvolution::Affiliates do
  let(:klass) { TicketEvolution::Affiliates}
  let(:single_klass) { TicketEvolution::Affiliate}
  let(:instance) { klass.new({:parent => Fake.connection}) }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a show endpoint'

  it "should respond to create_affiliate" do
    instance.should respond_to :create_affiliate
  end

  describe "#create_affiliate_credential" do
    context "with an id" do
      let(:instance) { klass.new({:parent => Fake.connection, :id => 1}) }
      let(:params) {{ :id => instance.id }}

      it "should pass call request as a POST, with no params" do
        instance.should_receive(:request).with(:POST, "/create_affiliate_credential", params)

        instance.create_affiliate_credential(params)
      end
    end
  end


end
