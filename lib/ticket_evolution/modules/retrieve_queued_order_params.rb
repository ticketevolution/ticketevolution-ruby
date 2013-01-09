module TicketEvolution
  module Modules
    module RetrieveQueuedOrderParams
      def retrieve_queued_order_params(id, params = nil, &handler)
        handler ||= method(:build_for_retrieve_queued_order_params)
        request(:GET, "/retrieve_queued_order_params/#{id}", params, &handler)
      end

      def build_for_retrieve_queued_order_params(response)
        response.body['order_params']
      end
    end
  end
end
