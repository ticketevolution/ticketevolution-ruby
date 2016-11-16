module TicketEvolution
  class AffiliateCommissions < Endpoint
    include TicketEvolution::Modules::Show

    alias :find_by_office :show

    # Find affiliate commission of the office at the time the order was created
    def find_by_office_order(office_id, order_link_id, params=nil)
      request(:GET, "/#{office_id}/orders/#{order_link_id}", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end
  end
end
