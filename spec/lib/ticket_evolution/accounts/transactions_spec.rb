require 'spec_helper'

describe TicketEvolution::Accounts::Transactions do
  let(:klass) { TicketEvolution::Accounts::Transactions }
  let(:single_klass) { TicketEvolution::Transaction }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'

  it "should have a base path of /transactions" do
    klass.new({:parent => Fake.connection}).base_path.should == '/transactions'
  end
end
