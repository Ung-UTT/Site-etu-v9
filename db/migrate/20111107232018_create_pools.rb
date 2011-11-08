class CreatePools < ActiveRecord::Migration
  def change
    create_table :pools do |t|
      t.string     :name
      t.text       :description
      t.references :user

      t.timestamps
    end
  end
end
