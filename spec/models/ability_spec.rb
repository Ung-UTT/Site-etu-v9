require 'spec_helper'

# Helper to spoof an user identity
def as(user)
  before do
    @user = user ? create(user) : nil
    @ability = Ability.new @user
  end

  subject { @ability }
end

describe Ability do
  # XXX: We don't test all abilities here, it would be redundant with the model.
  # Instead, we test at least one ability for each context.

  context 'as an anonymous user' do
    as nil
    it { should be_able_to(:read, Classified.new) }
    it { should_not be_able_to(:read, User.new) }
  end

  context 'as an authenticated user' do
    as :user
    it { should be_able_to(:manage, User, id: @user.id) }
  end

  context 'as a student' do
    as :student
    it { should be_able_to(:create, News) }
  end

  context 'as a moderator' do
    as :moderator
    it { should be_able_to(:manage, Asso) }
  end

  context 'as an administrator' do
    as :administrator
    it { should be_able_to(:manage, :all) }
  end
end
