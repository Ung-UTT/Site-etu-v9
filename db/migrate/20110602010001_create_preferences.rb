class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.string     :locale
      t.string     :quote_type
      t.references :user

      t.timestamps
    end

    add_index :preferences, :user_id
  end
end
