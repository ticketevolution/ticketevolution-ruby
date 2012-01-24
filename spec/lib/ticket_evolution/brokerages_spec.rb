require 'spec_helper'

describe TicketEvolution::Brokerages do
  let(:klass) { TicketEvolution::Brokerages }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a search endpoint'
  it_behaves_like 'a show endpoint'
end