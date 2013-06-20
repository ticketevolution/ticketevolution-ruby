module TicketEvolution
  module Modules
    module Raw
      def raw(params = nil, &handler)
        handler ||= method(:raw_handler)
        request(:GET, nil, params, &handler)
      end
    end
  end
end
