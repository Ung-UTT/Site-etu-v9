class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :login
      t.string    :email
      t.boolean   :cas
      t.string    :crypted_password
      t.string    :password_salt
      t.string    :perishable_token
      t.datetime  :perishable_token_date

      t.timestamps
    end

    add_index :users, ['login'], :name => 'index_users_on_login', :unique => true
  end

  def self.down
    drop_table :users
  end
end
