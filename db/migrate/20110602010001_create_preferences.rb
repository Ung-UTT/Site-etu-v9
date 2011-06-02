class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.string     :locale
      t.string     :quote_type # none, quotes, tooltips
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end
