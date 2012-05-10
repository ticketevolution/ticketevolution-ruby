module TicketEvolution
  module Modules
    module Destroy
      def self.included(klass)
        Class.new{extend SingularClass}.singular_class(klass.name).send(:include, Module.new{
          def destroy
            response = plural_class.new({:parent => @connection, :id => self.id}).destroy
            if response === true
              self.freeze
            end

            response
          end

          alias :delete :destroy
        })
      end

      def destroy(&handler)
        ensure_id
        handler ||= method(:build_for_destroy)
        request(:DELETE, "/#{id}", nil, &handler)
      end

      def build_for_destroy(response)
        return true
      end
    end
  end
end

