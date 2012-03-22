class TimesheetsUser < ActiveRecord::Base
  attr_accessible :user_id, :timesheet_id

  belongs_to :user
  belongs_to :timesheet
end
