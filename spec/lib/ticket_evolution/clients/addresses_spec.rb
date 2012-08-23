require 'spec_helper'

describe TicketEvolution::Clients::Addresses do
  let(:klass) { TicketEvolution::Clients::Addresses }
  let(:single_klass) { TicketEvolution::Address }
  let(:instance) { klass.new({:parent => Fake.connection}) }
  let(:update_base) { {'url' => '/clients/1/addresses/1'} }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
  it_behaves_like 'an update endpoint'

  describe "#fedex_check" do
    context "with params" do
      let(:params) { }

      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, "/1/fedex_check", params)
        instance.fedex_check(1)
      end
    end
  end

end
