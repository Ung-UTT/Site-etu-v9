require 'spec_helper'

describe Document do
  describe 'validations' do
    it { should validate_presence_of(:asset) }
    it { should validate_attachment_presence(:asset) }
  end

  it 'can be added to some contents' do
    annal = build :annal
    doc = Document.new(:asset => file_from_assets('image.png'))
    doc.documentable = annal
    doc.save
    annal.documents.should include doc

    classified = build :classified
    doc2 = Document.new(:asset => file_from_assets('image.ico'))
    doc2.documentable = classified
    doc2.save
    classified.documents.should include doc2
  end

  it 'should detect images' do
    doc = Document.create(:asset => file_from_assets('image.png'))
    doc.image?.should be_true

    doc = Document.create(:asset => file_from_assets('image.ico'))
    doc.image?.should be_false

    doc = Document.create(:asset => file_from_assets('document.pdf'))
    doc.image?.should be_false

    doc = Document.create(:asset => file_from_assets('document.doc'))
    doc.image?.should be_false
  end
end
