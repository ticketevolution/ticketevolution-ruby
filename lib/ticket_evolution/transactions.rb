module TicketEvolution
  class Transactions < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Create
    include TicketEvolution::Modules::Show
  end
end
