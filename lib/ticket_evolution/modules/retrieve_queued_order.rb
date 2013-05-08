module TicketEvolution
  module Modules
    module RetrieveQueuedOrder
      def retrieve_queued_orders(&handler)
        handler ||= method(:collection_handler)
        request(:GET, "/queued_orders", &handler)
      end

    end
  end
end
