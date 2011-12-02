require 'spec_helper'

describe Timesheet do
  fixtures :users

  describe 'Validations' do
    it { should validate_presence_of(:day) }
    it { should validate_presence_of(:from) }
    it { should validate_presence_of(:to) }
    it { should validate_presence_of(:course) }
  end

  describe 'Associations' do
    it { should belong_to(:course) }

    it { should have_many(:users).through(:timesheets_user) }
  end

  describe 'Methods' do
    it 'should have a correct during? method' do
      c = Course.create(:name => 'Course')
      t = Timesheet.create(:day => 1, :from => '8:00:00', :to => '12:00:00', :course => c)
      t.during?(1, t.from + 2.hours).should be_true
      t.during?(1, t.to).should be_true
      t.during?(0, t.from + 2.hours).should be_false
      t.during?(1, t.from - 2.hours).should be_false
    end
  end
end
