require 'spec_helper'

describe TicketEvolution::TicketGroups::TicketHolds do
  let(:klass) { TicketEvolution::TicketGroups::TicketHolds }
  let(:single_klass) { TicketEvolution::TicketHold }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
end
