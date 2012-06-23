require 'spec_helper'

describe Activity do
  it "adds and retrieves activities" do
    activity = HashWithIndifferentAccess.new(
      who: "John",
      what: "watched",
      thing: "Nyan Cat"
    )

    Activity.add activity
    Activity.get(0).should == activity
    Activity.last(1).first.should == activity
  end
end

