module TicketEvolution
  class Clients
    class Addresses < TicketEvolution::Endpoint
      include TicketEvolution::Modules::Create
      include TicketEvolution::Modules::List
      include TicketEvolution::Modules::Show
      include TicketEvolution::Modules::Update
      include TicketEvolution::Modules::Destroy

      def fedex_check(id, params=nil, &handler)
        handler ||= method(:fedex_check_handler)
        request(:GET, "/#{id}/fedex_check", nil, &handler)
      end

      def fedex_check_handler(response)
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end

      def fedex_check_fields(params=nil, &handler)
        handler ||= method(:fedex_check_fields_handler)
        params = { endpoint_name.to_sym => [params] } if params.present?
        request(:POST, "/fedex_check_fields", params, &handler)
      end

      def fedex_check_fields_handler(response)
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end

    end
  end
end
