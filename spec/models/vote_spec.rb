require 'spec_helper'

describe Vote do
  fixtures :users

  describe 'Validations' do
    it 'should not allow to vote on two answers of the same poll' do
      p = Poll.create(:name => 'Poll vote')
      a1 = Answer.create(:content => 'Answer 1 vote', :poll_id => p.id)
      a2 = Answer.create(:content => 'Answer 2 vote', :poll_id => p.id)
      Vote.new(:answer_id => a1.id, :user_id => users(:kevin).id).save.should be_true
      Vote.new(:answer_id => a2.id, :user_id => users(:kevin).id).save.should be_false
    end
  end

  describe 'Associations' do
    it { should belong_to(:answer) }
    it { should belong_to(:user) }
  end
end
