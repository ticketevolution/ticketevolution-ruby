require 'spec_helper'

describe TicketEvolution::TicketGroups do
  let(:klass) { TicketEvolution::TicketGroups }
  let(:single_klass) { TicketEvolution::TicketGroup }
  let(:update_base) { {'url' => '/ticket_groups/1'} }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
  it_behaves_like 'an update endpoint'

  it "should have a base path of /ticket_groups" do
    klass.new({:parent => Fake.connection}).base_path.should == '/ticket_groups'
  end

  context "integration tests" do
    let(:instance) { klass.new({:parent => connection}) }
    use_vcr_cassette "ticket_groups/index_cart", :record => :new_episodes

    it "returns a list of ticket_groups with ids in params[:id].split" do
      instance.should_receive(:request).with(:GET, "/index_cart", '1,2')
      instance.index_cart('1,2')
    end
  end
end
