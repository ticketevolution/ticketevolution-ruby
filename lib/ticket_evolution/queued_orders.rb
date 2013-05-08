module TicketEvolution
  class QueuedOrders < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show

    def list_recent
      request(:GET, '/recent', &method(:collection_handler))
    end
  end
end
