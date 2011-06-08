class CreateAnnals < ActiveRecord::Migration
  def self.up
    create_table :annals do |t|
      t.string     :name
      t.text       :description
      t.references :course
      t.datetime   :date

      t.timestamps
    end
  end

  def self.down
    drop_table :annals
  end
end
