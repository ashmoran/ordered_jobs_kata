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

    specify { subject.sequence.should order_element("c").before("b") }
  end

  context "Multiple Jobs, Multiple Dependencies" do
    subject {
      JobStructure.new(-%{
        a =>
        b => c
        c => f
        d => a
        e => b
        f =>
      })
    }

    its(:sequence) { should =~ %w[ a b c d e f ] }

    specify { subject.sequence.should order_element("f").before("c") }
    specify { subject.sequence.should order_element("c").before("b") }
    specify { subject.sequence.should order_element("b").before("e") }
    specify { subject.sequence.should order_element("a").before("d") }
  end

  context "Multiple Jobs, Self Referencing Dependency" do
    it "raises an error" do
      expect {
        JobStructure.new(-%{
          a =>
          b =>
          c => c
        })
      }.to raise_error(ArgumentError) { |error|
        error.message.should eq %Q{Job "c" can't depend on itself}
      }
    end
  end
end
