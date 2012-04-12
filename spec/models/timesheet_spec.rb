require 'spec_helper'

describe Timesheet do
  describe 'validations' do
    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:end_at) }
    it { should validate_presence_of(:course) }
  end
end
