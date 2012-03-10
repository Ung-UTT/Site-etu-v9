class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.datetime   :start_at # Lundi 20 février à 8h
      t.datetime   :end_at # Lundi 20 février à 10h
      t.string     :semester # P2012, A2012, ... (définie dans
      t.string     :week # rien, A ou B
      t.string     :room # A201, B205, ...
      t.references :course

      t.timestamps
    end
  end
end
