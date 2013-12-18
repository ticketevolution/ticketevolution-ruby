module TicketEvolution
  class Affiliates < Endpoint
    include TicketEvolution::Modules::Create
    include TicketEvolution::Modules::Show

    alias :create_affiliate :create

    def create_affiliate_credential(params=nil)
      ensure_id
      request(:POST, "/create_affiliate_credential", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end
  end
end
