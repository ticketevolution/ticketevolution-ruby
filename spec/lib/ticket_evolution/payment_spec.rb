require 'spec_helper'

describe TicketEvolution::Payment do
  subject { TicketEvolution::Payment }
  let(:klass) { TicketEvolution::Payment }
  let(:connection) { Fake.connection }
  let(:instance) { klass.new({ :connection => connection, 'id' => 1 }) }
  let(:params) { { :order_id => 1 } }
  let(:plural_klass) { TicketEvolution::Orders::Payments}
  let!(:plural_klass_instance) { plural_klass.new(:parent => connection) }

  it_behaves_like "a ticket_evolution model"

  describe '#apply' do
    before do
      plural_klass.should_receive(:new).with(:parent => connection, :id => instance.id).and_return(plural_klass_instance)
    end

    it 'should pass the request to TicketEvolution::Orders::Payments#apply' do
      plural_klass_instance.should_receive(:apply).with(params).and_return(:dont_care)
      instance.apply(params)
    end
  end

  describe '#cancel' do
    before do
      plural_klass.should_receive(:new).with(:parent => connection, :id => instance.id).and_return(plural_klass_instance)
    end

    it 'should pass the request to TicketEvolution::Orders::Payments#cancel' do
      plural_klass_instance.should_receive(:cancel).with(params).and_return(:dont_care)
      instance.cancel(params)
    end
  end
end
