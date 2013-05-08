module TicketEvolution
  class CreditMemos
    class CreditMemoPayments < TicketEvolution::Endpoint
      include TicketEvolution::Modules::List
      include TicketEvolution::Modules::Show
      include TicketEvolution::Modules::Create

      def apply(params = {})
        ensure_id
        request(:GET, '/apply', params) do |response|
          singular_class.new(response.body.merge({
            :status_code => response.response_code,
            :server_message => response.server_message,
            :connection => response.body[:connection]
          }))
        end
      end

      def cancel(params = nil)
        ensure_id
        request(:GET, "/cancel", nil) do |response|
          singular_class.new(response.body.merge({
            :status_code => response.response_code,
            :server_message => response.server_message,
            :connection => response.body[:connection]
          }))
        end
      end
    end
  end
end
