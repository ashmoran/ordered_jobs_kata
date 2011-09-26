require 'spec_helper'
require_relative '../lib/ordered_jobs'

describe "Ordered Jobs" do
  context "Empty String" do
    subject { JobStructure.new("") }
    its(:sequence) { should eq [ ] }
  end

  context "Single Job" do
    subject { JobStructure.new("a => ") }
    its(:sequence) { should eq %w[ a ] }
  end

  context "Multiple Jobs" do
    subject {
      JobStructure.new(-%{
        a => 
        b => 
        c => 
      })
    }

    its(:sequence) { should =~ %w[ a b c ] }
  end
end
