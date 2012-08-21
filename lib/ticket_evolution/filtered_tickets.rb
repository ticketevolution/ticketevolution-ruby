module TicketEvolution
  class FilteredTickets < Endpoint
    def taken(params)
      handler ||= method(:collection_handler)
      request(:GET, '/taken', params, &handler)
    end
    def held(params)
      handler ||= method(:collection_handler)
      request(:GET, '/held', params, &handler)
    end
  end
end
