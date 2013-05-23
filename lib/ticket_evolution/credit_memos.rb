module TicketEvolution
  class CreditMemos < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Update

    def cards(params = nil)
      ensure_id
      request(:GET, "/cards", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

  end
end

