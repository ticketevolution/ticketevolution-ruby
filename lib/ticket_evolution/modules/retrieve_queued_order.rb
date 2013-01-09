module TicketEvolution
  module Modules
    module RetrieveQueuedOrder
      def retrieve_queued_order(id, params = nil, &handler)
        handler ||= method(:build_for_retrieve_queued_order)
        request(:GET, "/retrieve_queued_order/#{id}", params, &handler)
      end

      def build_for_retrieve_queued_order(response)
        response.body
      end
    end
  end
end
