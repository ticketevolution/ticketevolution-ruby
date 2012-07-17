module TicketEvolution
  class Orders < Endpoint
    include TicketEvolution::Modules::Create
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Update

    alias :create_brokerage_order :create
    alias :create_client_order :create
    alias :create_customer_order :create

    def balance(params = nil)
      request(:GET, '/balance', params, &method(:build_for_show))
    end

    def accept_order(params = nil)
      ensure_id
      request(:POST, "/#{self.id}/accept", params, &method(:build_for_create))
    end

    def create_fulfillment_order(params = nil)
      request(:POST, "/fulfillments", params, &method(:build_for_create))
    end

    def reject_order(params = nil)
      ensure_id
      request(:POST, "/#{self.id}/reject", params, &method(:build_for_create))
    end

    def complete_order
      ensure_id
      request(:POST, "/#{self.id}/complete", nil, &method(:build_for_create))
    end
  end
end
