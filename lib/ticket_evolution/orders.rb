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

    def pend_to_seller
      ensure_id
      request(:POST, "/pend_to_seller", &method(:build_for_show))
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

    def email_order(params = nil)
      ensure_id
      request(:POST, "/email", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

    def email_etickets_link(params = nil)
      ensure_id
      request(:POST, "/email_etickets_link", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

    def store_etickets(params = nil)
      deliver_etickets(params)
    end

    def deliver_etickets(params = nil)
      ensure_id
      request(:POST, "/deliver_etickets", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

    def print_etickets(params = nil)
      ensure_id
      request(:GET, "/print_etickets", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

    def print_order
      ensure_id
      request(:GET, "/print", nil) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

  end
end
