require 'spec_helper'

describe News do
  it { should validate_presence_of(:title) }

  describe "is_moderated" do
    it "needs moderator role to be set" do
      expect {
        News.new({is_moderated: true})
      }.to raise_error ActiveModel::MassAssignmentSecurity::Error

      expect {
        News.new({is_moderated: true}, as: :moderator)
      }.to_not raise_error ActiveModel::MassAssignmentSecurity::Error
    end
  end
end

