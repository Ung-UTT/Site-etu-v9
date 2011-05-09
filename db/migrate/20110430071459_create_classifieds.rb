class CreateClassifieds < ActiveRecord::Migration
  def self.up
    create_table :classifieds do |t|
      t.string  :title
      t.text    :content
      t.decimal :price
      t.string  :location
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :classifieds
  end
end
