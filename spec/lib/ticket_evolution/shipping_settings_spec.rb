require 'spec_helper'

describe TicketEvolution::ShippingSettings do
  let(:klass) { TicketEvolution::ShippingSettings }
  let(:single_klass) { TicketEvolution::ShippingSetting }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
end
