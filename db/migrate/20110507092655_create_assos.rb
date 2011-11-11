class CreateAssos < ActiveRecord::Migration
  def self.change
    create_table :assos do |t|
      t.string     :name
      t.text       :description
      t.references :owner
      t.references :parent
      t.integer    :lft
      t.integer    :rgt

      t.timestamps
    end
  end
end
