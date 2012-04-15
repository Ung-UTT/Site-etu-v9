class CreateWikis < ActiveRecord::Migration
  def change
    create_table :wikis do |t|
      t.string     :title
      t.text       :content
      t.references :role
      t.references :parent

      # Générés
      t.integer    :lft
      t.integer    :rgt

      t.timestamps
    end

    add_index :wikis, :role_id
  end
end
