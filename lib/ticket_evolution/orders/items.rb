module TicketEvolution
  class Orders
    class Items < TicketEvolution::Endpoint
      include TicketEvolution::Modules::List
      include TicketEvolution::Modules::Show

      def print_etickets
        ensure_id
        request(:GET, '/print_etickets', nil) do |response|
          singular_class.new(response.body.merge({
            :status_code => response.response_code,
            :server_message => response.server_message,
            :connection => response.body[:connection]
          }))
        end
      end

      def remove_etickets
        ensure_id
        request(:GET, '/remove_etickets', nil) do |response|
          singular_class.new(response.body.merge({
            :status_code => response.response_code,
            :server_message => response.server_message,
            :connection => response.body[:connection]
          }))
        end
      end

      def add_etickets(params = nil)
        ensure_id
        request(:POST, "/add_etickets", params) do |response|
          singular_class.new(response.body.merge({
            :status_code => response.response_code,
            :server_message => response.server_message,
            :connection => response.body[:connection]
          }))
        end
      end

      def finalize_etickets(params = nil)
        ensure_id
        request(:POST, "/finalize_etickets", params) do |response|
          singular_class.new(response.body.merge({
            :status_code => response.response_code,
            :server_message => response.server_message,
            :connection => response.body[:connection]
          }))
        end
      end
    end
  end
end
