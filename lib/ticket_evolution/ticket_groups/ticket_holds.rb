module TicketEvolution
  class TicketGroups
    class TicketHolds < TicketEvolution::Endpoint
      include TicketEvolution::Modules::List
    end
  end
end
