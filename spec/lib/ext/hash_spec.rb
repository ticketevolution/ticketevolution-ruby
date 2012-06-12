require 'spec_helper'

describe 'Hash' do
  let(:hash) { { :one => 1, :two => 2, :three => 3 } }
  let(:ordered_hash) { hash.to_ordered_hash }

  it "should respond to #to_ordered_hash" do
    hash.should respond_to :to_ordered_hash
  end

  describe "#to_ordered_hash" do
    it "should return an instance of ActiveSupport::OrderedHash" do
      ordered_hash.should be_an ActiveSupport::OrderedHash
    end

    it "should contain the same key value pairs as the original" do
      hash.keys.should =~ ordered_hash.keys
      hash.each do |k, v|
        ordered_hash[k].should == v
      end
    end

    it "should order it's keys alphabetically" do
      keys = ordered_hash.keys.clone
      keys.sort_by{|x|x.to_s}.should == ordered_hash.keys
    end

    context "when a value is an array" do
      let(:hash) { { :one => [2, 3, 1], :two => ['b', 'a', 'c'] } }

      it "should sort the array" do
        ordered_hash[:one].should == [1, 2, 3]
        ordered_hash[:two].should == ['a', 'b', 'c']
      end
    end
  end
end
