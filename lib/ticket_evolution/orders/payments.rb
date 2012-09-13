module TicketEvolution
  class Orders
    class Payments < TicketEvolution::Endpoint
      include TicketEvolution::Modules::List
      include TicketEvolution::Modules::Show
      include TicketEvolution::Modules::Create
      include TicketEvolution::Modules::Update

      def apply(params = nil)
        _ensure_id(params)
        request(:POST, "/#{params[:id]}/apply", params, &method(:build_for_show))
      end

      def cancel(params = nil)
        _ensure_id(params)
        request(:POST, "/#{params[:id]}/cancel", params, &method(:build_for_show))
      end

      def refund(id,params=nil, &handler)
        handler ||= method(:refund_handler)
        params = { endpoint_name.to_sym => [params] } if params.present?
        request(:GET, "/#{id}/refund", params, &method(:build_for_show))
      end

      def refund_handler(response)
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end

      private

      def _ensure_id(params)
        raise TicketEvolution::MethodUnavailableError.new \
          "#{self.class.to_s}##{caller.first.split('`').last.split("'").first} can only be called if there is an id present on this #{self.class.to_s} instance" \
          unless params && params[:id].present?
      end
    end
  end
end
