module TicketEvolution
  class Affiliates < Endpoint
    include TicketEvolution::Modules::Create

    alias :create_affiliate :create

    def create_affiliate_credential(params)
      request(:POST, "/#{params[:id]}/create_affiliate_credential", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end
  end
end
