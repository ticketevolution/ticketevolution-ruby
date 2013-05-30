module TicketEvolution
  class Credentials < Endpoint
    def list(params = {})
      request(:GET, '/', params, &method(:build))
    end

    def build(response)
      response.body
    end
  end
end
