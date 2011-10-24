class AddImageToAssos < ActiveRecord::Migration
  def self.up
    change_table :assos do |t|
      t.references :image
    end
  end

  def self.down
    remove_column :assos, :image
  end
end
