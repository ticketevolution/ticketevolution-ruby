module TicketEvolution
  class Orders
    class Payments < TicketEvolution::Endpoint
      include TicketEvolution::Modules::List
      include TicketEvolution::Modules::Show
      include TicketEvolution::Modules::Create

      def apply(params = nil)
        ensure_id(params)
        request(:POST, "/#{params[:id]}/apply", params, &method(:build_for_show))
      end

      def cancel(params = nil)
        ensure_id(params)
        request(:POST, "/#{params[:id]}/cancel", params, &method(:build_for_show))
      end

      private

      def ensure_id(params)
        raise TicketEvolution::MethodUnavailableError.new \
          "#{self.class.to_s}##{caller.first.split('`').last.split("'").first} can only be called if there is an id present on this #{self.class.to_s} instance" \
          unless params && params[:id].present?
      end
    end
  end
end
