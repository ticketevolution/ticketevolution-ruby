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

    before do
      plural_klass.should_receive(:new).with(:parent => connection).and_return(plural_klass_instance)
    end

    describe "#accept" do
      it "should pass the request to TicketEvolution::Orders#accept_order" do
        plural_klass_instance.should_receive(:accept_order).with(params).and_return(:dont_care)

        instance.accept(params)
      end
    end

    describe "#pend_to_seller" do
      it "should pass the request to TicketEvolution::Orders#pend_to_seller" do
        plural_klass_instance.should_receive(:pend_to_seller).with(params).and_return(:dont_care)

        instance.pend_to_seller(params)
      end
    end

    describe "#complete" do
      it "should pass the request to TicketEvolution::Orders#complete_order" do
        plural_klass_instance.should_receive(:complete_order).and_return(:dont_care)

        instance.complete
      end
    end

    describe "#reject" do
      it "should pass the request to TicketEvolution::Orders#reject_order" do
        plural_klass_instance.should_receive(:reject_order).with(params).and_return(:dont_care)

        instance.reject(params)
      end
    end
  end
end
