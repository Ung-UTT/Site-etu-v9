require 'spec_helper'

describe Answer do
  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:poll) }
  end

  describe '#voted_by' do
    before do
      @answer = create :answer
      @user = create :user
      @answer.votes << create(:vote, user: @user)
    end

    it "returns true if the user has already voted for this answer" do
      @answer.voted_by?(@user).should be_true
    end

    it "returns false if the user didn't vote for this answer" do
      @other_user = create :user
      @answer.voted_by?(@other_user).should be_false
    end
  end

  describe '#percent' do
    it "returns the correct percentage" do
      @answer = create :answer
      @answer.votes << create(:vote)
      @answer.percent.should == 100
    end

    it "return 0 when there is no votes" do
      @answer = create :answer
      @answer.percent.should == 0
    end
  end

  it "describe itself correctly" do
    answer = build :answer
    answer.to_s.should include answer.content.first(10)
  end
end
