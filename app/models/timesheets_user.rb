class TimesheetsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :timesheet
end
