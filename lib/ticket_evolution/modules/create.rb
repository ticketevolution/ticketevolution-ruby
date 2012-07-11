module TicketEvolution
  module Modules
    module Create
      def create(params = nil, &handler)
        handler ||= method(:build_for_create)
        params = { endpoint_name.to_sym => [params].flatten } if params.present?
        request(:POST, nil, params, &handler)
      end

      def build_for_create(response)
        entries = response.body[endpoint_name].collect do |body|
          singular_class.new(body.merge({
            :status_code => response.response_code,
            :server_message => response.server_message,
            :connection => response.body[:connection]
          }))
        end
        if entries.size == 1
          entries.first
        else
          TicketEvolution::Collection.new(:entries => entries, :status_code => response.response_code)
        end
      end
    end
  end
end
