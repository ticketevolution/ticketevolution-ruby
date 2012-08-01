require 'spec_helper'

describe TicketEvolution::Settings do
  let(:klass) { TicketEvolution::Settings }
  let(:single_klass) { TicketEvolution::ShippingSetting }

  it_behaves_like 'a ticket_evolution endpoint class'

  context "shipping integration tests" do
    use_vcr_cassette "endpoints/settings", :record => :new_episodes

    it "returns a list of results for shipping action" do
      search_results = connection.settings.shipping()

      search_results.each do |result|
        result.should be_a TicketEvolution::Model
      end
    end
  end

  context "service_fees integration tests" do
    use_vcr_cassette "endpoints/settings_service_fees", :record => :new_episodes

    it "returns a list of results for service_fees action" do
      search_results = connection.settings.service_fees()

      search_results.each do |result|
        result.should be_a TicketEvolution::Model
      end
    end
  end
end
