require 'spec_helper'

describe TicketEvolution::Offices::CreditCards do
  let(:klass) { TicketEvolution::Offices::CreditCards }
  let(:single_klass) { TicketEvolution::CreditCard }
  let(:update_base) { { 'url' => '/offices/1/credit_cards/1' } }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'an update endpoint'
end
