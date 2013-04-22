module TicketEvolution
  class Quote < Model

    def resend
      plural_class.new(:parent => @connection,:id => self.id).resend
    end

  end
end
