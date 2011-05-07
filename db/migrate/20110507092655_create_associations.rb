class CreateAssociations < ActiveRecord::Migration
  def self.up
    create_table :associations do |t|
      t.string  :name
      t.text    :description
      t.integer :president_id

      t.timestamps
    end
  end

  def self.down
    drop_table :associations
  end
end
