module TicketEvolution
  class Commissions < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show

    def pay(params = nil)
      request(:POST, "/pay", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

  end
end
