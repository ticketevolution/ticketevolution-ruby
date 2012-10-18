module TicketEvolution
  class Brokerages < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Search
    include TicketEvolution::Modules::Show

    def tags(params)
      ensure_id
      request(:GET, "/tags", params) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

  end
end
