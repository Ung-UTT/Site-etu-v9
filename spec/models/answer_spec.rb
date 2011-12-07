require 'spec_helper'

describe Answer do
  fixtures :users

  describe 'Validations' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:poll) }
  end

  describe 'Associations' do
    it { should belong_to(:poll) }

    it { should have_many(:votes) }
  end

  describe 'Methods' do
    #FIXME: Ça devrait bien fonctionner
    it 'should know if a user has already vote a answer' do
      p = Poll.create(:name => 'Poll')
      a = Answer.create(:poll => p, :content => 'Answer')
      #a.voted_by?(users(:kevin)).should be_false
      #a.votes << Vote.create(:user => users(:kevin))
      #a.voted_by?(users(:kevin)).should be_true
    end
  end
end
