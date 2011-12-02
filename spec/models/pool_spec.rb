require 'spec_helper'

describe Pool do
  fixtures :pools, :users

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }

    it { should have_many(:answers) }
    it { should have_many(:votes) }
  end

  describe 'Methods' do
    it 'should know if user has already votes' do
      p = Pool.create(:name => 'Pool answer?')
      p.answers << Answer.create(:content => 'Answer')
      Vote.create(:answer => p.answers.first, :user => users(:kevin))
      p.voted_by?(users(:kevin)).should be_true
      p.voted_by?(users(:joe)).should be_false
    end
  end
end
