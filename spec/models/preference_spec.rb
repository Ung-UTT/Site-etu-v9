require 'spec_helper'

describe Preference do
  fixtures :users

  describe 'Validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:user_id) }
    it { should allow_value('fr').for(:locale) }
    it { should allow_value('en').for(:locale) }
    it { should_not allow_value('francais').for(:locale) }
    it { should allow_value('all').for(:quote_type) }
    it { should_not allow_value('viva la carioca').for(:quote_type) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
  end
end
