require 'spec_helper'

describe Timesheet do
  describe 'Validations' do
    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:end_at) }
    it { should validate_presence_of(:course) }
  end

  describe 'Associations' do
    it { should belong_to(:course) }

    it { should have_many(:users).through(:timesheets_user) }
  end
end
