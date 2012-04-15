class CreateAssos < ActiveRecord::Migration
  def change
    create_table :assos do |t|
      t.string     :name
      t.string     :website
      t.string     :email
      t.text       :description
      t.references :owner
      t.references :image
      t.references :parent

      # Générés
      t.integer    :lft
      t.integer    :rgt

      t.timestamps
    end

    add_index :assos, :owner_id
  end
end
