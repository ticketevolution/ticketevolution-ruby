module TicketEvolution
  class Payments < Endpoint
    include TicketEvolution::Modules::Create
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Update

    def apply(params = nil)
      ensure_id
      request(:POST, "/#{params[:id]}/apply", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

    def cancel(params = nil)
      ensure_id
      request(:POST, "/#{params[:id]}/cancel", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

    def refund(params = nil)
      ensure_id
      request(:POST, "/#{params[:id]}/refund", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end
  end
end
