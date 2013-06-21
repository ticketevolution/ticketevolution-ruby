module TicketEvolution
  module Modules
    module List
      def list(params = nil, &handler)
        handler ||= method(:collection_handler)
        request(:GET, nil, params, &handler)
      end

      def raw(params = nil, &handler)
        handler ||= method(:raw_handler)
        request(:GET, nil, params, &handler)
      end

      alias :all :list
    end
  end
end
