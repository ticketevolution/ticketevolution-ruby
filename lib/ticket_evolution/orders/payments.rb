module TicketEvolution
  class Orders
    class Payments < TicketEvolution::Endpoint
      include TicketEvolution::Modules::List
      include TicketEvolution::Modules::Show
      include TicketEvolution::Modules::Create

      def apply(params = nil)
        ensure_id
        request(:POST, '/apply', params, &method(:build_for_show))
      end

      def cancel(params = nil)
        ensure_id
        request(:POST, '/cancel', params, &method(:build_for_show))
      end
    end
  end
end
