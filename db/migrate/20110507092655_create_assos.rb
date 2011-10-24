class CreateAssos < ActiveRecord::Migration
  def self.up
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

  def self.down
    drop_table :assos
  end
end
