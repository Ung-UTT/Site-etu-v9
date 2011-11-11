class AddImageToAssos < ActiveRecord::Migration
  def self.change
    change_table :assos do |t|
      t.references :image
    end
  end
end
