module TicketEvolution
  class Model < Builder
    def initialize(params = {})
      @connection = params.delete(:connection)
      raise TicketEvolution::ConnectionNotFound.new \
        "#{self.class.name} must receive a TicketEvolution::Connection object on initialize" \
        unless @connection.is_a? TicketEvolution::Connection
      @scope = params['url'].split('/')[0..2].join('/') if params['url'] =~ /^(\/[a-z_]+s\/\d+){2}$/
      super(params)
    end

    def plural_class_name
      parts = ["TicketEvolution", self.class.name.demodulize.pluralize.camelize]
      parts[0] = self.scope[:class] if @scope.present?
      parts.join('::')
    end

    def plural_class
      self.plural_class_name.constantize rescue nil
    end

    def attributes
      HashWithIndifferentAccess.new(to_hash)
    end

    def attributes=(params)
      params.each do |k, v|
        send("#{k}=", v)
      end
    end

    def scope
      if @scope.present?
        {}.tap do |scope|
          parts = @scope.split('/')
          scope[:class] = "TicketEvolution::#{parts[1].camelize}"
          scope[:id] = parts[2].to_i
        end
      else
        nil
      end
    end

    private

    def process_datum(v, k=nil)
      if v.is_a? Hash and v['url'].present?
        name = class_name_from_url(v['url'])
        datum_exists?(name) ? singular_class(class_name_from_url(name)).new(v.merge({:connection => @connection})) : Datum.new(v)
      else
        super
      end
    end

    def method_missing(method, *args)
      begin
        "#{plural_class_name}::#{method.to_s.camelize}".constantize.new(:parent => plural_class.new(:parent => @connection, :id => self.id))
      rescue
        super
      end
    end
  end
end



