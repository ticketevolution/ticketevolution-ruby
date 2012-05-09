require 'spec_helper'

describe TicketEvolution::Client do
  subject { TicketEvolution::Client }

  describe "when calling a nested endpoint method" do
    use_vcr_cassette "endpoints/clients", :record => :new_episodes

    let(:client) { TicketEvolution::Clients.new(:parent => connection).list.first }

    it "should pass the request to the appropriate endpoint and get back an appropriate response" do
      collection = client.email_addresses.list
      collection.should be_a TicketEvolution::Collection
      collection.total_entries.should == collection.size
      collection.first.should be_a TicketEvolution::EmailAddress
    end
  end

  it_behaves_like "a ticket_evolution model"
  it_behaves_like "a parental model"

  describe "a retrieved instance" do
    use_vcr_cassette "endpoints/clients/list", :record => :new_episodes, :match_requests_on => [:method, :uri, :body]

    let(:client) { connection.clients.list(:per_page => 1) }

    it "should be capable of being marshaled" do
      expect {
        Marshal.dump(client)
      }.to_not raise_error
    end
  end

  context "#update_attributes" do
    let(:client) { connection.clients.create(:name => "foo") }
    let(:initial_client_id) { client.id }

    context "on success" do
      use_vcr_cassette "endpoints/clients/update_success", :record => :new_episodes, :match_requests_on => [:method, :uri, :body]
      before { client }

      it "updates the attributes of the instance" do
        client_instance = client.update_attributes(:name => "bar")
        client_instance.should be_an_instance_of TicketEvolution::Client
        client.id.should == initial_client_id
        client.name.should == "bar"

        retrieved_client = connection.clients.find(initial_client_id)
        retrieved_client.name.should == "bar"
      end
    end

    context "on error" do
      use_vcr_cassette "endpoints/clients/update_fail", :record => :new_episodes, :match_requests_on => [:method, :uri, :body]
      before { client }

      it "doesn't update the attributes of the instance" do
        ret = client.update_attributes(:name => "")
        client.id.should == initial_client_id
        client.name.should == "foo"
        ret.should be_an_instance_of TicketEvolution::ApiError
        ret.code.should == 422

        retrieved_client = connection.clients.find(initial_client_id)
        retrieved_client.name.should == "foo"
      end
    end
  end
end
