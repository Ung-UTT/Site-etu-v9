class CreateProjects < ActiveRecord::Migration
  def self.change
    create_table :projects do |t|
      t.string     :name
      t.text       :description
      t.references :owner

      t.timestamps
    end
  end
end
