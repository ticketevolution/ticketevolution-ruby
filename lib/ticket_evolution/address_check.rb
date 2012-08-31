module TicketEvolution
  class AddressCheck < TicketEvolution::Endpoint
    def check_fields(params=nil, &handler)
      handler ||= method(:check_fields_handler)
      params = { endpoint_name.to_sym => [params] } if params.present?
      request(:POST, nil, params, &handler)
    end

    def check_fields_handler(response)
      response.body.merge({
        :status_code => response.response_code,
        :server_message => response.server_message,
        :connection => response.body[:connection]
      })
    end

  end
end
