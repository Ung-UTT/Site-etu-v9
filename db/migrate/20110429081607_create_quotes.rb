class CreateQuotes < ActiveRecord::Migration
  def self.change
    create_table :quotes do |t|
      t.string     :content
      t.references :user

      t.timestamps
    end
  end
end
