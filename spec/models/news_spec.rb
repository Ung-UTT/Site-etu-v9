require 'spec_helper'

describe News do
  it { should validate_presence_of(:title) }

  it 'describe itself correctly' do
    news = build :news
    news.to_s.should include news.title
  end
end

