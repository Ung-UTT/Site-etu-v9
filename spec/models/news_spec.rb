require 'spec_helper'

describe News do
  it { should validate_presence_of(:title) }

  it 'describe itself correctly' do
    news = build :news
    news.to_s.include?(news.title).should be_true
  end
end

