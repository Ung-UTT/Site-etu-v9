require 'spec_helper'

describe Vote do
  fixtures :users

  describe 'Validations' do
    it 'should not allow to vote on two answers of the same pool' do
      p = Pool.create(:name => 'Pool vote')
      a1 = Answer.create(:content => 'Answer 1 vote', :pool => p)
      a2 = Answer.create(:content => 'Answer 2 vote', :pool => p)
      Vote.new(:answer => a1, :user => users(:kevin)).save.should be_true
      Vote.new(:answer => a2, :user => users(:kevin)).save.should be_false
    end
  end

  describe 'Associations' do
    it { should belong_to(:answer) }
    it { should belong_to(:user) }
  end
end
