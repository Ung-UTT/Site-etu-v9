require 'spec_helper'

describe Comment do
  it 'can be added to some contents' do
    comment = build(:comment)
    news = build(:news)
    comment.commentable = news
    comment.save
    news.comments.should include comment
  end
end
