module TicketEvolution
  class Accounts
    class Transactions < TicketEvolution::Endpoint
      include TicketEvolution::Modules::Create
      include TicketEvolution::Modules::List
      include TicketEvolution::Modules::Show

      def balances(params = nil)
        request(:GET, "/balances", params) do |response|
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
