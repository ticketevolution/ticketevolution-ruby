module TicketEvolution
  class TicketGroup < Model
    def hold(params)
      plural_class.new(:parent => @connection).hold(params)
    end
  end
end
