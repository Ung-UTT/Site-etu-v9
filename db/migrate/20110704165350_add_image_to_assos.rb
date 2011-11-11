class AddImageToAssos < ActiveRecord::Migration
  def change
    change_table :assos do |t|
      t.references :image
    end
  end
end
