require 'spec_helper'

describe UserDecorator do
  describe "#to_s" do
    it "includes both firstname and lastname" do
      user = build :user, firstname: "Joe", lastname: "Dupont"
      UserDecorator.new(user).to_s.should include "#{user.firstname} #{user.lastname}"
    end
  end
end
