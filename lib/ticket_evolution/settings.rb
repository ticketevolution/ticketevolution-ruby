module TicketEvolution
  class Settings < Endpoint
    include TicketEvolution::Modules::Show

    def shipping_setting(params= {})
      request(:GET, "/shipping_setting", params, &method(:build_for_show))
    end

    def shipping(params = {})
      request(:GET, "/shipping", params, &method(:build_for_shipping))
    end

    def build_for_shipping(response)
      collection = TicketEvolution::Collection.new(
        :total_entries => response.body['total_entries']
      )

      response.body['settings'].each do |result|
        collection.entries << "TicketEvolution::ShippingSetting".
          constantize.new(result.merge({:connection => connection}))
      end

      collection
    end

    def service_fees(params = {})
      request(:GET, "/service_fees", params, &method(:build_for_service_fees))
    end

    def build_for_service_fees(response)
      collection = TicketEvolution::Collection.new(
        :total_entries => response.body['total_entries']
      )

      response.body['settings'].each do |result|
        collection.entries << "TicketEvolution::ServiceFee".
          constantize.new(result.merge({:connection => connection}))
      end

      collection
    end

    def singular_class(klass = self.class)
      TicketEvolution::ShippingSetting
    end
  end
end

