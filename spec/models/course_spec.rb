require 'spec_helper'

describe Course do
  it 'can add users via timesheets' do
    user = build :user
    course = create :course
    course.timesheets << build(:timesheet)
    course.timesheets.first.users << user

    course.users.should include user
  end
end
