class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.string     :content
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :quotes
  end
end
