require 'spec_helper'

describe TicketEvolution::Orders::Payments do
  let(:klass) { TicketEvolution::Orders::Payments }
  let(:single_klass) { TicketEvolution::Payment }
  let(:update_base) { {'url' => '/orders/1/payments/1'} }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'an update endpoint'

  context 'integration tests' do
    let(:instance) { klass.new({ :parent => connection }) }

    describe 'apply' do
      let(:instance) { klass.new({ :parent => connection, :id => 1 }) }
      use_vcr_cassette 'payments/apply'

      it 'applies a payment' do
        instance.should_receive(:request).with(:POST, '/1/apply', { :order_id => 1, :id => 1 })
        instance.apply({ :order_id => 1, :id => 1 })
      end
    end

    describe 'cancel' do
      let(:instance) { klass.new({ :parent => connection, :id => 1 }) }
      use_vcr_cassette 'payments/cancel'

      it 'applies a payment' do
        instance.should_receive(:request).with(:POST, '/1/cancel', { :order_id => 1, :id => 1 })
        instance.cancel({ :order_id => 1, :id => 1 })
      end
    end
  end
end
