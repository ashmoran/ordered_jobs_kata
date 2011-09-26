require 'spec_helper'
require_relative '../lib/ordered_jobs'

describe "Ordered Jobs" do
  context "empty input" do
    it "returns an empty sequence" do
      JobStructure.new("").sequence.should eq [ ]
    end
  end
end
