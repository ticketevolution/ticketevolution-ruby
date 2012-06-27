module TicketEvolution
  class TicketGroups < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Update

    def index_cart(ids = [])
      handler ||= method(:collection_handler)
      request(:GET, '/index_cart', ids, &handler)
    end
  end
end
