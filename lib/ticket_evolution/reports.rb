module TicketEvolution
  class Reports < Endpoint
    def sales(params = {})
      request(:GET, '/sales', params, &method(:build_for_reports))
    end

    def inventory(params = {})
      request(:GET, '/inventory', params, &method(:build_for_reports))
    end

    def build_for_reports(response)
      response.body['reports']
    end
  end
end
