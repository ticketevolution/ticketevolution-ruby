module TicketEvolution
  class Clients
    class CreditCards < TicketEvolution::Endpoint
      include TicketEvolution::Modules::Create
      include TicketEvolution::Modules::List
      include TicketEvolution::Modules::Update
      include TicketEvolution::Modules::Destroy
    end
  end
end
