module TicketEvolution
  class CustomPages < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
  end
end
