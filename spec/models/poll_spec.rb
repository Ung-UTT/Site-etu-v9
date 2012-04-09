require 'spec_helper'

describe Poll do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }

    it { should have_many(:answers) }
    it { should have_many(:votes) }
  end

  describe '#voted_by?' do
    it 'should know if user has already votes' do
      kevin = FactoryGirl.create :user, login: "kevin"
      joe = FactoryGirl.create :user, login: "joe"
      poll = FactoryGirl.create :poll_with_answers
      FactoryGirl.create(:vote, answer: poll.answers.sample, user: kevin)

      poll.voted_by?(kevin).should be_true
      poll.voted_by?(joe).should be_false
    end
  end
end
