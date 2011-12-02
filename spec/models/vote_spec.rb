require 'spec_helper'

describe Vote do
  fixtures :users

  describe 'Validations' do
    it 'should not allow to vote on two questions of the same pool' do
      p = Pool.create(:name => 'Pool vote')
      q1 = Question.create(:content => 'Question 1 vote', :pool => p)
      q2 = Question.create(:content => 'Question 2 vote', :pool => p)
      Vote.new(:question => q1, :user => users(:kevin)).save.should be_true
      Vote.new(:question => q2, :user => users(:kevin)).save.should be_false
    end
  end

  describe 'Associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end
end
