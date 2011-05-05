class CreateCarpools < ActiveRecord::Migration
  def self.up
    create_table :carpools do |t|
      t.text     :content
      t.string   :location
      t.datetime :date
      t.boolean  :is_driver
      t.integer  :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :carpools
  end
end
