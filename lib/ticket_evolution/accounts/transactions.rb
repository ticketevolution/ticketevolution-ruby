module TicketEvolution
  class Accounts
    class Transactions < TicketEvolution::Endpoint
      include TicketEvolution::Modules::List
      include TicketEvolution::Modules::Show
    end
  end
end
