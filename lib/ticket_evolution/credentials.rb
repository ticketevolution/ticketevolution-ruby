module TicketEvolution
  class Credentials < Endpoint
    include TicketEvolution::Modules::List

    def me(params = {})
      handler ||= method(:raw_handler)
      request(:GET, '/me', params, &handler)
    end
  end
end
