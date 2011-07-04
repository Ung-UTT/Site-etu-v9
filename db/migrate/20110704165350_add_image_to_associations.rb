class AddImageToAssociations < ActiveRecord::Migration
  def self.up
    change_table :associations do |t|
      t.references :image
    end
  end

  def self.down
    remove_column :associations, :image
  end
end
