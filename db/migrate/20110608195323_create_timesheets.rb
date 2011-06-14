class CreateTimesheets < ActiveRecord::Migration
  def self.up
    create_table :timesheets do |t|
      t.datetime   :start
      t.datetime   :end
      t.string     :classroom
      t.references :course

      t.timestamps
    end
  end

  def self.down
    drop_table :timesheets
  end
end
