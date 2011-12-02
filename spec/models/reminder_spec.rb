require 'spec_helper'

describe Reminder do
  fixtures :users

  describe 'Validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
  end
end
