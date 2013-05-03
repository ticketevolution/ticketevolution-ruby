module TicketEvolution
  class Searches < Endpoint
    def suggestions(params = {})
      request(:GET, '/suggestions', params, &method(:build_for_search))
    end

    def build_for_search(response)
      response.body['suggestions']
    end
  end
end
