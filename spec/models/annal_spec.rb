require 'spec_helper'

describe Annal do
  it "can have one attached document" do
    doc = build :document
    annal = build :annal, document: doc
    annal.document.should == doc
  end

  it "cannot have no attached document" do
    annal = build :annal, document: nil
    annal.should be_invalid
  end
end
