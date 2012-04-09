require 'spec_helper'

describe Vote do
  describe 'validations' do
    it 'should not allow to vote on two answers of the same poll' do
      user = FactoryGirl.create :user
      poll = FactoryGirl.create :poll_with_answers

      params = { answer: poll.answers.first, user: user }
      FactoryGirl.create(:vote, params)
      FactoryGirl.build(:vote, params).should be_invalid
    end
  end
end
