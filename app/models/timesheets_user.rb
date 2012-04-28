class TimesheetsUser < ActiveRecord::Base
  belongs_to :timesheet
  belongs_to :user
end
