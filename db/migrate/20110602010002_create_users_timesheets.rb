class CreateUsersTimesheets < ActiveRecord::Migration
  def self.up
    create_table :users_timesheets, :id => false do |t|
      t.references :user
      t.references :timesheet

      t.timestamps
    end
  end

  def self.down
    drop_table :users_timesheets
  end
end
