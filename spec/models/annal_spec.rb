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
    annal.to_s.include?(annal.course.name).should be_true
    annal.to_s.include?(annal.year.to_s).should be_true
    annal.to_s.include?(annal.semester).should be_true
  end
end
