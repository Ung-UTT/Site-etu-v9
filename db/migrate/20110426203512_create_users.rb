class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  :login
      t.string  :email
      t.string  :crypted_password
      t.string  :password_salt
      t.boolean :cas

      t.timestamps
    end

    add_index :users, ['login'], :name => 'index_users_on_login', :unique => true
    add_index :users, ['email'], :name => 'index_users_on_email', :unique => true
  end

  def self.down
    drop_table :users
  end
end
