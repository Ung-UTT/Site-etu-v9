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

  it "describe itself correctly" do
    annal = build :annal
    annal.to_s.should include annal.course.name
    annal.to_s.should include annal.year.to_s
    annal.to_s.should include annal.semester
  end
end
