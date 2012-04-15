class CreateAnnals < ActiveRecord::Migration
  def change
    create_table :annals do |t|
      t.string     :name
      t.text       :description
      t.references :course
      t.date       :date

      t.timestamps
    end

    add_index :annals, :course_id
  end
end
