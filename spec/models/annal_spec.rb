require 'spec_helper'

describe Annal do
  it "can have an attached document" do
    doc = build :document
    annal = build :annal, documents: [doc]
    annal.documents.should == [doc]
  end

  it "cannot have no attached document" do
    annal = build :annal, documents: []
    annal.should be_invalid
  end
end
