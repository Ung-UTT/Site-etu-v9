require 'spec_helper'

describe Classified do
  it "can have attached documents" do
    classified = build :classified
    doc = build :document
    doc.documentable = classified
    doc.save
    classified.documents.should include doc
  end

  it 'describe itself correctly' do
    classified = build :classified
    classified.to_s.should include classified.title.first(10)
  end
end
