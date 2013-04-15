module TicketEvolution
  class Quotes < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Search
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Create
    include TicketEvolution::Modules::Update
  end
end
