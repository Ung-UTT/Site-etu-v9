class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :login
      t.string    :email
      t.boolean   :cas

      # Générés
      t.string    :crypted_password
      t.string    :password_salt
      t.string    :perishable_token # Pour "mot de passe oublié"
      t.datetime  :perishable_token_date #    //
      t.string    :auth_token # Pour "Se souvenir de moi"

      t.timestamps
    end

    add_index :users, ['login'], :name => 'index_users_on_login', :unique => true
  end
end
