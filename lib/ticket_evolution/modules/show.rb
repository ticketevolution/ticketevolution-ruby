module TicketEvolution
  module Modules
    module Show
      def show(id)
        request(:GET, "/#{id}", &method(:build_for_show))
      end

      alias :find :show

      def build_for_show(response)
        singular_class.new(
          response.body.merge({
          :status_code => response.response_code,
          :server_message => response.server_message
        })
        )
      end
    end
  end
end
