# encoding: utf-8

require 'spec_helper'

describe User do
  describe 'validations' do
    it { should_not allow_value('bla').for(:email) }
    it { should_not allow_value('bla@bla').for(:email) }
    it { should allow_value('bla@bla.bla').for(:email) }

    it 'should reject incorrect confirmation password' do
      user = build :user, password: 'good password'
      user.password_confirmation = 'bad password'
      user.should be_invalid
    end
  end

  describe "#administrators" do
    it "returns all administrators" do
      administrators = [ create(:administrator), create(:administrator) ]
      User.administrators.should =~ administrators
    end

    it "returns only administrators" do
      user = create(:user)
      user.has_role?(:administrator).should be_false
      User.administrators.should_not include user
    end
  end

  describe "#students" do
    it "returns all students" do
      students = [ create(:student), create(:student) ]
      User.students.should =~ students
    end

    it "returns only students" do
      user = create(:user)
      user.has_role?(:student).should be_false
      User.students.should_not include user
    end
  end

  describe "#search" do
    it "works with simple search" do
      joe = create :user, login: 'joe'
      User.search('joe').should include joe
    end

    it "works with non [a-z]" do
      accent = create :user, firstname: 'Accentué'
      User.search('accentue').should include accent
    end

    it "works with partial search" do
      full = create :user, firstname: 'full'
      User.search('fu').should include full
    end

    it "ignores the case" do
      camel = create :user, firstname: 'STranGeCAse'
      User.search('strangecase').should include camel
      User.search('STRANGECASE').should include camel
      User.search('StrangeCase').should include camel
    end
  end

  describe "#simple_create" do
    it "should create a user with a password" do
      expect {
        User.simple_create("simplewithpass", "superpass")
      }.to change{User.count}.by(1)
    end

    it "should create a user without a password" do
      expect {
        User.simple_create("simplewithoutpass")
      }.to change{User.count}.by(1)
    end
  end

  context 'with a user' do
    before do
      @user ||= create(:user)
    end

    it 'should have preference' do
      @user.preference.should_not be_nil
    end

    it 'should have many courses' do
      @user.courses.should == []
    end

    it 'should correctly respond for abilities' do
      @user.has_role?(:fake_role).should be_false
    end
  end

  it 'describe itself correctly' do
    user = build :user, firstname: "#1"
    user.to_s.should include user.firstname
  end
end
