require 'spec_helper'

describe TicketEvolution::Shipment do
  subject { TicketEvolution::Shipment }

  it_behaves_like "a ticket_evolution model"

  context "custom methods" do
    let(:connection) { Fake.connection }
    let(:instance) { TicketEvolution::Shipment.new({:connection => connection, 'id' => 1}) }
    let(:plural_klass) { TicketEvolution::Shipments}
    let!(:plural_klass_instance) { plural_klass.new(:parent => connection) }

    before do
      plural_klass.should_receive(:new).with(:parent => connection, :id => 1).and_return(plural_klass_instance)
    end

    describe "#generate_airbill" do
      it "should pass the request to TicketEvolution::Shipments#generate_airbill" do
        plural_klass_instance.should_receive(:generate_airbill).and_return(:dont_care)

        instance.generate_airbill
      end
    end

    describe "#email_airbill" do
      it "should pass the request to TicketEvolution::Shipments#email_airbill" do
        plural_klass_instance.should_receive(:email_airbill).and_return(:dont_care)

        instance.email_airbill
      end
    end

    describe "#cancel" do
      it "should pass the request to TicketEvolution::Shipments#cancel_shipment" do
        plural_klass_instance.should_receive(:cancel_shipment).and_return(:dont_care)

        instance.cancel
      end
    end
  end
end
