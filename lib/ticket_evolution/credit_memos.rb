module TicketEvolution
  class CreditMemos < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Update
  end
end

