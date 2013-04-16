module TicketEvolution
  class Shipments < Endpoint
    include TicketEvolution::Modules::Create
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Update

    def status(params = {})
      handler ||= method(:collection_handler)
      request(:GET, '/status', params, &handler)
    end

    def get_airbill(params = {})
      ensure_id

      request(:GET, "/get_airbill", nil) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
   end

    def generate_airbill(params = nil)
      ensure_id
      request(:POST, "/airbill", nil) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

    def email_airbill(params = nil)
      ensure_id
      request(:POST, "/email_airbill", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end


    def cancel_shipment(params = nil)
      ensure_id

      request(:PUT, "/cancel", nil) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

    def pend_shipment(params = nil)
      ensure_id

      request(:GET, "/pend", nil) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

    def deliver_shipment(params = nil)
      ensure_id

      request(:GET, "/deliver", nil) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end
  end
end
