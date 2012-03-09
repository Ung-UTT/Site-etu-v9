class CreateAnnals < ActiveRecord::Migration
  def change
    create_table :annals do |t|
      t.string     :name
      t.text       :description
      t.references :course
      t.date       :date

      t.timestamps
    end
  end
end
