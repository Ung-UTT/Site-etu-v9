require 'spec_helper'

describe Course do
  fixtures :courses, :users

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { should have_many(:annals) }
    it { should have_many(:timesheets) }
    it { should have_many(:comments) }
    it { should have_many(:documents) }
    it { should have_many(:users).through(:timesheets) }

    it 'can add users via timesheets' do
      courses(:LE00).timesheets << Timesheet.create(:start_at => Time.now,
                          :end_at => Time.now + 2.hour, :category => 'CM')
      courses(:LE00).timesheets.first.users << users(:kevin)
      courses(:LE00).users.include?(users(:kevin)).should be_true
      courses(:LE00).timesheets.first.users.delete(users(:kevin))
      courses(:LE00).users.include?(users(:kevin)).should be_false
    end
  end
end
