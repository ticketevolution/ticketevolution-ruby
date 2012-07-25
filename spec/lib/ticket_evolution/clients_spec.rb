require 'spec_helper'

describe TicketEvolution::Clients do
  let(:klass) { TicketEvolution::Clients }
  let(:single_klass) { TicketEvolution::Client }
  let(:update_base) { {} }

  it_behaves_like 'a ticket_evolution endpoint class'
  it_behaves_like 'a create endpoint'
  it_behaves_like 'a list endpoint'
  it_behaves_like 'a show endpoint'
  it_behaves_like 'an update endpoint'

  describe "integrations" do
    context "#create" do
      use_vcr_cassette "endpoints/clients/create", :record => :new_episodes, :match_requests_on => [:method, :uri, :body]

      it "returns validation errors" do
        client = connection.clients.create(:name => "")
        client.should be_an_instance_of TicketEvolution::ApiError
      end

      it "successfully creates a client" do
        name = "Comish Gordon"
        client = connection.clients.create(:name => name)

        client.should be_instance_of TicketEvolution::Client
        client.id.should be
        client.name.should == name

        same_client = connection.clients.show(client.id)
        same_client.id.should == client.id
        same_client.name.should == name
      end
    end

    describe '#create_from_office' do
      use_vcr_cassette 'endpoints/clients/create_from_office'

      let(:instance) { klass.new({ :parent => connection })}

      it "creates a client from a given office_id" do
        instance.should_receive(:request).with(:POST, '/create_from_office/1', nil)
        instance.create_from_office({ :office_id => 1})
      end
    end
  end

  describe "chained endpoints" do
    context "when the parent endpoint has an id" do
      it "should check for chained endpoints in the method_missing stack" do
        endpoint = klass.new(:parent => connection, :id => 1).samples
        endpoint.should be_a TicketEvolution::Clients::Samples
      end
    end
  end
end
