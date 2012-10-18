module TicketEvolution
  class Brokerage < Model

    def tags(params)
      plural_class.new(:parent => @connection,:id => self.id).tags(params)
    end

  end
end
