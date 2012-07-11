require 'spec_helper'

describe TicketEvolution::Orders::Payments do
  let(:klass) { TicketEvolution::Orders::Payments }
  let(:single_klass) { TicketEvolution::Payment }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a list endpoint'
end
