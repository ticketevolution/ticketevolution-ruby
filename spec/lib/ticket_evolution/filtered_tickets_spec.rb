require 'spec_helper'

describe TicketEvolution::FilteredTickets do

  let(:klass) { TicketEvolution::FilteredTickets }
  let(:single_klass) { TicketEvolution::FilteredTicket }
  let(:instance) { klass.new({:parent => Fake.connection}) }

  it_behaves_like 'a ticket_evolution endpoint class'

  describe "#taken" do
    context "with params" do
      let(:params) { {'some' => {'order' => 'info'}} }

      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, "/taken", params)
        instance.taken(params)
      end
    end
  end

  describe "#held" do
    context "with params" do
      let(:params) { {'some' => {'order' => 'info'}} }

      it "should pass call request as a GET, passing params" do
        instance.should_receive(:request).with(:GET, "/held", params)
        instance.held(params)
      end
    end
  end

end