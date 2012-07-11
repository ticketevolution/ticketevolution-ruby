module TicketEvolution
  module EndpointBehavior
    def endpoint=(e); @endpoint = e; end
    def method_missing(method, *args)
      @endpoint.send(method, *args)
    end
  end

  class Model
    module ParentalBehavior
      def process_datum(v, k = nil)
        v = super
        if k and v.is_a? Array and v.singleton_class.ancestors.first == Array
          e = "#{self.plural_class_name}::#{k.to_s.chomp('=').camelize}".constantize.new({
            :parent => endpoint
          })
          v.extend(TicketEvolution::EndpointBehavior)
          v.endpoint = e
        end
      ensure
        return v
      end

      def new_ostruct_member(name)
        name = name.to_sym
        unless self.respond_to?(name)
          class << self; self; end.class_eval do
            define_method(name) { @table[name.to_sym] }
            define_method("#{name}=") { |x| modifiable[name] = process_datum(x, name) }
          end
        end
        name
      rescue NameError => e
        super
      end
    end
  end
end
