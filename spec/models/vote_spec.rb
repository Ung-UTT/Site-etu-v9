require 'spec_helper'

describe Vote do
  describe 'validations' do
    it 'should not allow to vote on two answers of the same poll' do
      user = create :user
      poll = create :poll_with_answers

      params = { answer: poll.answers.first, user: user }
      create(:vote, params)
      build(:vote, params).should be_invalid
    end
  end
end
