module TicketEvolution
  class PromotionCodes < Endpoint
    include TicketEvolution::Modules::Deleted
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Search
    include TicketEvolution::Modules::Show
  end
end
