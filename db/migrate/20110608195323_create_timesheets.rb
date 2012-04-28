class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      # On a besoin du premier cours du semestre, le site gérera la
      # répétition du cours
      t.datetime   :start_at # Lundi 20 février à 8h
      t.integer    :duration # Durée en minutes (60 = 1h, 90 = 1h30)
      t.string     :week # rien, A ou B
      t.string     :room # A201, B205, ...
      t.string     :category # CM, TD, TP
      t.references :course

      t.timestamps
    end

    add_index :timesheets, :course_id
  end
end
