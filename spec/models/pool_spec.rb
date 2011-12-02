require 'spec_helper'

describe Pool do
  fixtures :pools, :users

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }

    it { should have_many(:questions) }
    it { should have_many(:votes) }
  end

  describe 'Methods' do
    it 'should know if user has already votes' do
      p = Pool.create(:name => 'Pool question?')
      p.questions << Question.create(:content => 'Answer')
      Vote.create(:question => p.questions.first, :user => users(:kevin))
      p.voted_by?(users(:kevin)).should be_true
      p.voted_by?(users(:joe)).should be_false
    end
  end
end
