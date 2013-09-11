module TicketEvolution
  class Cities < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
  end
end

