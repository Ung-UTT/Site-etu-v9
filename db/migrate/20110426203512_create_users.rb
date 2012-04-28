class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, :null => false, :default => ""
      t.string :email, :null => false, :default => ""

      t.timestamps
    end

    add_index :users, :login, :unique => true
    add_index :users, :email, :unique => true
  end
end
