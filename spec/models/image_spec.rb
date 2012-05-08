require 'spec_helper'

describe Image do
  describe 'Validations' do
    it { should validate_attachment_content_type(:name) }
  end

  describe 'Methods' do
    it 'should only accept images' do
      img = Image.new(asset: file_from_assets('image.png'))
      img.save.should be_true
      img = Image.new(asset: file_from_assets('image.ico'))
      img.save.should be_false
      img = Image.new(asset: file_from_assets('document.pdf'))
      img.save.should be_false
    end
  end
end
