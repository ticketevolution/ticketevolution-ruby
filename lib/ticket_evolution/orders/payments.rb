module TicketEvolution
  class Orders
    class Payments < TicketEvolution::Endpoint
      include TicketEvolution::Modules::List
      include TicketEvolution::Modules::Create
    end
  end
end
