class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.integer    :day  # 0-6 (Lundi-Dimanche)
      t.time       :from # Time.now, 08:00:00, ...
      t.time       :to   # Pareil
      t.string     :week # rien, A ou B
      t.string     :room # A201, B205, ...
      t.references :course

      t.timestamps
    end
  end
end
