require 'spec_helper'

describe Poll do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '#voted_by?' do
    it 'should know if user has already votes' do
      kevin = create :user, login: "kevin"
      joe = create :user, login: "joe"
      poll = create :poll_with_answers
      create(:vote, answer: poll.answers.sample, user: kevin)

      poll.voted_by?(kevin).should be_true
      poll.voted_by?(joe).should be_false
    end
  end

  it 'describe itself correctly' do
    poll = build :poll
    poll.to_s.include?(poll.name).should be_true
  end
end
