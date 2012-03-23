require 'spec_helper'

describe Document do
  fixtures :users, :annals, :classifieds

  describe 'Validations' do
    it { should validate_presence_of(:asset) }
    it { should validate_attachment_presence(:asset) }
  end

  describe 'Associations' do
    it { should belong_to(:documentable) }

    it 'can be added to some contents' do
      doc = Document.new(:asset => file_from_assets('image.png'))
      doc.documentable = annals(:medianLE00)
      doc.save
      annals(:medianLE00).documents.include?(doc).should be_true

      doc2 = Document.new(:asset => file_from_assets('image.ico'))
      doc2.documentable = classifieds(:magic)
      doc2.save
      classifieds(:magic).documents.include?(doc2).should be_true
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
end
