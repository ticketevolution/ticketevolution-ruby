require 'spec_helper'

shared_examples_for "a ticket_evolution error class" do
  it(:ancestors) { should include Exception }
end
