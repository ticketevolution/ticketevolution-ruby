module TicketEvolution
  module Modules
    module CreateInBackground
      def create_in_background(params = nil, &handler)
        handler ||= method(:build_for_create_in_background)
        params = { endpoint_name.to_sym => [params] } if params.present?
        request(:POST, '/background', params, &handler)
      end

      def build_for_create_in_background(response)
        response.body
      end
    end
  end
end
