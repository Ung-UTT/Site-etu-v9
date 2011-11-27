class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.string     :locale
      t.string     :quote_type # all, quotes, tooltips, jokes, none
      t.references :user

      t.timestamps
    end
  end
end
