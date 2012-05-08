require 'spec_helper'

describe Comment do
  it 'can be added to some contents' do
    comment = build(:comment)
    news = build(:news)
    comment.commentable = news
    comment.save
    news.comments.should include comment
  end

  it 'describe itself correctly' do
    comment = build :comment
    comment.to_s.should include comment.content.first(10)
  end
end
