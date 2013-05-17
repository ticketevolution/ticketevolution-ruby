module TicketEvolution
  class Reports < Endpoint
    def sales(params = {})
      request(:GET, '/reports/sales', params, &method(:build_for_reports))
    end

    def inventory(params = {})
      request(:GET, '/reports/inventory', params, &method(:build_for_reports))
    end

    def build_for_reports(response)
      response.body['reports']
    end
  end
end
