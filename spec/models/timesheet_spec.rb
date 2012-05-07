require 'spec_helper'

describe Timesheet do
  describe 'validations' do
    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:duration) }
    it { should validate_presence_of(:course) }
  end

  it 'describe itself correctly' do
    timesheet = build :timesheet
    timesheet.to_s.include?(timesheet.course.name).should be_true
  end
end
