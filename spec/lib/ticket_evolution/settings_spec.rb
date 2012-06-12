require 'spec_helper'

describe TicketEvolution::Settings do
  let(:klass) { TicketEvolution::Settings }
  let(:single_klass) { TicketEvolution::ShippingSetting }

  it_behaves_like 'a ticket_evolution endpoint class'

  context "integration tests" do
    use_vcr_cassette "endpoints/settings", :record => :new_episodes

    it "returns a list of results" do
      search_results = connection.settings.shipping()

      search_results.each do |result|
        result.should be_a TicketEvolution::Model
      end
    end
  end
end
