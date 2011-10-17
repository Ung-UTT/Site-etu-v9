class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  :login
      t.string  :email
      t.boolean :cas
      t.string  :crypted_password
      t.string  :password_salt
      # t.string  :perishable_token # ??? TODO: À compléter pour "mot de passe oublié"

      t.timestamps
    end

    add_index :users, ['login'], :name => 'index_users_on_login', :unique => true
  end

  def self.down
    drop_table :users
  end
end
