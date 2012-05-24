module TicketEvolution
  class Settings < Endpoint
    def shipping(params = {})
      request(:GET, "/shipping", params, &method(:build_for_search))
    end

    def build_for_search(response)
      collection = TicketEvolution::Collection.new(
        :total_entries => response.body['total_entries']
      )

      response.body['settings'].each do |result|
        collection.entries << "TicketEvolution::ShippingSetting".
          constantize.new(result.merge({:connection => connection}))
      end

      collection
    end

    def singular_class(klass = self.class)
      TicketEvolution::ShippingSetting
    end
  end
end

