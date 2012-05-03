class CreateAnnals < ActiveRecord::Migration
  def change
    create_table :annals do |t|
      t.string     :semester
      t.integer    :year
      t.string     :kind
      t.references :course

      t.timestamps
    end

    add_index :annals, :course_id
  end
end
