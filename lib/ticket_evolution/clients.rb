module TicketEvolution
  class Clients < Endpoint
    include TicketEvolution::Modules::Create
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Update

    def create_from_office(params = nil)
      request(:POST, "/create_from_office/#{params[:office_id]}", nil, &method(:build_for_show))
    end
  end
end
