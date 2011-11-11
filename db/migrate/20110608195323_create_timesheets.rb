class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.integer    :day
      t.time       :from
      t.time       :to
      t.string     :week
      t.string     :room
      t.references :course

      t.timestamps
    end
  end
end
