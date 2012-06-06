require 'spec_helper'

describe ApplicationHelper do
  describe "#semester_of" do
    it "return the correct semester" do
      helper.semester_of(DateTime.new(2012, 5, 20, 10, 20)).should == 'P2012'
    end

    it "doesn't fail if it can't find any semester" do
      helper.semester_of(DateTime.new(42)).should_not be_blank
    end
  end
end
