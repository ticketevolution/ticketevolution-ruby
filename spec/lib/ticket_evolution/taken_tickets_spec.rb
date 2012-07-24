require 'spec_helper'

describe TicketEvolution::TakenTickets do

  let(:klass) { TicketEvolution::TakenTickets }
  let(:single_klass) { TicketEvolution::TakenTicket }
  let(:instance) { klass.new({:parent => Fake.connection}) }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'

end