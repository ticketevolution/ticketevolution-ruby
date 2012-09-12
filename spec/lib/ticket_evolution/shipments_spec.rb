require 'spec_helper'

describe TicketEvolution::Shipments do
  let(:klass) { TicketEvolution::Shipments }
  let(:instance) { klass.new({:parent => Fake.connection}) }
  let(:single_klass) { TicketEvolution::Shipment }
  let(:update_base) { {} }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'an update endpoint'
  it_behaves_like 'a show endpoint'

  describe "#generate_airbill" do
    context "with an id" do
      let(:instance) { klass.new({:parent => Fake.connection, :id => 1}) }

      it "should pass call request as a POST" do
        instance.should_receive(:request).with(:POST, "/airbill", nil)

        instance.generate_airbill
      end
    end

    context "without an id" do
      it "should raise an UnavailableMethodError if there is no id" do
        message = "#{klass.to_s}#generate_airbill can only be called if there is an id present on this #{klass.to_s} instance"
        expect { instance.generate_airbill }.to raise_error TicketEvolution::MethodUnavailableError, message
      end
    end
  end

  describe "#email_airbill" do
    context "with an id" do
      let(:instance) { klass.new({:parent => Fake.connection, :id => 1}) }

      it "should pass call request as a POST" do
        instance.should_receive(:request).with(:POST, "/email_airbill", nil)

        instance.email_airbill
      end
    end

    context "without an id" do
      it "should raise an UnavailableMethodError if there is no id" do
        message = "#{klass.to_s}#email_airbill can only be called if there is an id present on this #{klass.to_s} instance"
        expect { instance.email_airbill }.to raise_error TicketEvolution::MethodUnavailableError, message
      end
    end
  end

  describe "#cancel_shipment" do
    context "with an id" do
      let(:instance) { klass.new({:parent => Fake.connection, :id => 1}) }

      it "should pass call request as a POST" do
        instance.should_receive(:request).with(:PUT, "/cancel", nil)

        instance.cancel_shipment
      end
    end

    context "without an id" do
      it "should raise an UnavailableMethodError if there is no id" do
        message = "#{klass.to_s}#cancel_shipment can only be called if there is an id present on this #{klass.to_s} instance"
        expect { instance.cancel_shipment }.to raise_error TicketEvolution::MethodUnavailableError, message
      end
    end
  end
end
