module TicketEvolution
  class Quotes < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Search
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Create
    include TicketEvolution::Modules::Update

    def autocomplete(params = {})
      request(:GET, "/autocomplete", params, &method(:build_for_search))
    end

    def resend
      ensure_id
      request(:GET, "/resend", nil) do |response|
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message,
          :connection => response.body[:connection]
        }))
      end
    end

    def build_for_search(response)
      collection = TicketEvolution::Collection.new(
        :total_entries => response.body['total_entries'],
        :per_page => response.body['per_page'],
        :current_page => response.body['current_page']
      )

      response.body['results'].each do |result|
        collection.entries << result
      end

      collection
    end
  end
end
