require 'spec_helper'

describe Question do
  fixtures :users

  describe 'Validations' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:pool) }
  end

  describe 'Associations' do
    it { should belong_to(:pool) }

    it { should have_many(:votes) }
  end

  describe 'Methods' do
    #FIXME: Ça devrait bien fonctionner
    it 'should know if a user has already vote a question' do
      p = Pool.create(:name => 'Pool')
      q = Question.create(:pool => p, :content => 'Question')
      #q.voted_by?(users(:kevin)).should be_false
      #q.votes << Vote.create(:user => users(:kevin))
      #q.voted_by?(users(:kevin)).should be_true
    end
  end
end
