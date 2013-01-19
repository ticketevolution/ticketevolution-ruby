require 'spec_helper'

describe TicketEvolution::Order do
  subject { TicketEvolution::Order }
  let(:klass) { TicketEvolution::Order }

  it_behaves_like "a ticket_evolution model"
  it_behaves_like "a parental model"

  describe "custom methods" do
    let(:connection) { Fake.connection }
    let(:instance) { klass.new({:connection => connection, 'id' => 1}) }
    let(:params) { {:test => "1... 2... 3..."} }
    let(:plural_klass) { TicketEvolution::Orders }
    let!(:plural_klass_instance) { plural_klass.new(:parent => connection) }

    describe "#accept" do
      it "should pass the request to TicketEvolution::Orders#accept_order" do
        plural_klass.should_receive(:new).with(:parent => connection, :id => instance.id).and_return(plural_klass_instance)
        plural_klass_instance.should_receive(:accept_order).with(params).and_return(:dont_care)

        instance.accept(params)
      end
    end

    describe "#refund" do
      it "should pass the request to TicketEvolution::Orders#refund_order" do
        plural_klass.should_receive(:new).with(:parent => connection, :id => instance.id).and_return(plural_klass_instance)
        plural_klass_instance.should_receive(:refund_order).with(params).and_return(:dont_care)

        instance.refund(params)
      end
    end

    describe "#complete" do
      it "should pass the request to TicketEvolution::Orders#complete_order" do
        plural_klass.should_receive(:new).with(:parent => connection, :id => instance.id).and_return(plural_klass_instance)
        plural_klass_instance.should_receive(:complete_order).and_return(:dont_care)

        instance.complete
      end
    end

    describe "#reject" do
      it "should pass the request to TicketEvolution::Orders#reject_order" do
        plural_klass.should_receive(:new).with(:parent => connection, :id => instance.id).and_return(plural_klass_instance)
        plural_klass_instance.should_receive(:reject_order).with(params).and_return(:dont_care)

        instance.reject(params)
      end
    end
  end
end
