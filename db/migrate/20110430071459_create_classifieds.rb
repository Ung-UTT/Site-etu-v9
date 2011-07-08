class CreateClassifieds < ActiveRecord::Migration
  def self.up
    create_table :classifieds do |t|
      t.string     :title
      t.text       :description
      t.decimal    :price
      t.string     :location
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :classifieds
  end
end
