require 'spec_helper'

describe Document do
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
