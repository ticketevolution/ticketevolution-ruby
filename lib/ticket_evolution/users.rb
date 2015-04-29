module TicketEvolution
  class Users < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Search
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Create
  end
end
