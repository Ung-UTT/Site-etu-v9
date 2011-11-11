class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string     :title
      t.text       :content
      t.references :user
      t.references :event

      t.timestamps
    end
  end
end
