require 'spec_helper'

describe Comment do
  fixtures :comments, :users, :news, :classifieds

  describe 'Validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:commentable) }

    it 'can be added to some contents' do
      com = Comment.new(:content => 'Content', :user_id => users(:kevin).id)
      com.commentable = news(:lorem)
      com.save
      news(:lorem).comments.include?(com).should be_true

      com2 = Comment.create(:content => 'Content', :user_id => users(:joe).id)
      com2.commentable = classifieds(:magic)
      com2.save
      classifieds(:magic).comments.include?(com2).should be_true
    end
  end
end
