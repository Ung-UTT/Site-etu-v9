class CreateAnnals < ActiveRecord::Migration
  def self.change
    create_table :annals do |t|
      t.string     :name
      t.text       :description
      t.references :course
      t.datetime   :date

      t.timestamps
    end
  end
end
