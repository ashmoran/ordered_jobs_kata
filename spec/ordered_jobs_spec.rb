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

  context "Multiple Jobs, Single Dependency" do
    subject {
      JobStructure.new(-%{
        a => 
        b => c
        c => 
      })
    }

    its(:sequence) { should =~ %w[ a b c ] }

    specify { subject.sequence.index("c").should be < subject.sequence.index("b") }
  end
end
