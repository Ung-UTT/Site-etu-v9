require 'spec_helper'

describe Classified do
  it "can have attached documents" do
    classified = build :classified
    doc = build :document
    doc.documentable = classified
    doc.save
    classified.documents.should include doc
  end
end
