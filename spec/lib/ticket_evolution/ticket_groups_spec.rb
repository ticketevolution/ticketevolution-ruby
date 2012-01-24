require 'spec_helper'

describe TicketEvolution::TicketGroups do
  let(:klass) { TicketEvolution::TicketGroups }
  let(:single_klass) { TicketEvolution::TicketGroup }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
end
