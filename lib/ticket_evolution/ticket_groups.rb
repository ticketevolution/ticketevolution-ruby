module TicketEvolution
  class TicketGroups < Endpoint
    include TicketEvolution::Modules::List
    include TicketEvolution::Modules::Show
    include TicketEvolution::Modules::Create
    include TicketEvolution::Modules::Update

    def hold(params = nil)
      ensure_id
      request(:POST, "/hold", params, &method(:build_for_show))
    end

    def take(params = nil)
      ensure_id
      request(:POST, "/take", params, &method(:build_for_show))
    end

    def update_hold(params = nil)
      ensure_id
      request(:POST, "/update_hold/#{params[:ticket_hold_id]}", params, &method(:build_for_show))
    end

    def release_hold(params = nil)
      ensure_id
      request(:POST, "/release_hold/#{params[:ticket_hold_id]}", params, &method(:build_for_show))
    end

    def release_take(params = nil)
      ensure_id
      request(:POST, "/release_take/#{params[:ticket_taken_id]}", params, &method(:build_for_show))
    end

    def waste(params = nil)
      ensure_id
      request(:POST, "/waste", params, &method(:build_for_show))
    end

    def toggle_broadcast(params = nil)
      ensure_id
      request(:POST, "/broadcast", params, &method(:build_for_show))
    end

    def index_cart(ids = [])
      handler ||= method(:collection_handler)
      request(:GET, '/index_cart', ids, &handler)
    end

    def mass_index(params = {})
      handler ||= method(:collection_handler)
      request(:GET, '/mass_index', params, &handler)
    end

    def mass_update(params = {})
      handler ||= method(:collection_handler)
      request(:POST, '/mass_update', params, &handler)
    end

    def export(params = {})
        request(:POST, '/export', params) do |response|
          singular_class.new(response.body.merge({
            :status_code => response.response_code,
            :server_message => response.server_message,
            :connection => response.body[:connection]
          }))
        end
    end

    def import(params = {})
      handler ||= method(:collection_handler)
      request(:POST, '/import', params, &handler)
    end

    def upload_history(params = {})
      handler ||= method(:upload_history_handler)
      request(:GET, '/upload_history', params, &handler)
    end
  end
end
