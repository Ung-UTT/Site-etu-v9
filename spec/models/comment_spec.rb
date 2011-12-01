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
      com = Comment.create(:content => 'Content', :user => users(:kevin), :commentable => news(:lorem))
      news(:lorem).comments.include?(com).should be_true

      com2 = Comment.create(:content => 'Content', :user => users(:joe), :commentable => classifieds(:magic))
      classifieds(:magic).comments.include?(com2).should be_true
    end
  end
end
