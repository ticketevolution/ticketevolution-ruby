module TicketEvolution
  class Affiliate < Model
    include Model::ParentalBehavior

    def create_affiliate_credential
      plural_class.new(:parent => @connection, :id => self.id).create_affiliate_credential
    end
  end
end
