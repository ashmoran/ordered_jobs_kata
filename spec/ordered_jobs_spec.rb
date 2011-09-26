require 'spec_helper'
require_relative '../lib/ordered_jobs'

describe "Ordered Jobs" do
  context "empty input" do
    subject { JobStructure.new("") }
    its(:sequence) { should eq [ ] }
  end

  context "single job" do
    subject { JobStructure.new("a => ") }
    its(:sequence) { should eq %w[ a ] }
  end
end
