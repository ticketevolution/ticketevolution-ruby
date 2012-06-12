require 'spec_helper'

describe TicketEvolution::PurchaseOrders do
  let(:klass) { TicketEvolution::PurchaseOrders }
  let(:single_klass) { TicketEvolution::PurchaseOrder }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
end
