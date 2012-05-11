module TicketEvolution
  module Modules
    module Update
      def self.included(klass)
        Class.new{extend SingularClass}.singular_class(klass.name).send(:include, Module.new{
          def update_attributes(params)
            handle_update_response(endpoint.update(params))
          end

          def save
            atts = self.attributes
            id = atts.delete(:id)
            handle_update_response(endpoint.update(atts))
          end

          def handle_update_response(response)
            if response.is_a?(TicketEvolution::ApiError)
              response
            else
              self.attributes = response.attributes
              self
            end
          end
          private :handle_update_response
        })
      end

      def update(params = nil, &handler)
        ensure_id
        handler ||= method(:build_for_update)
        request(:PUT, nil, params, &handler)
      end

      def build_for_update(response)
        singular_class.new(response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message
        }))
      end
    end
  end
end
