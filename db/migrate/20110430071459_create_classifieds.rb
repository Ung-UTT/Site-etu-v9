class CreateClassifieds < ActiveRecord::Migration
  def change
    create_table :classifieds do |t|
      t.string     :title
      t.text       :description
      t.decimal    :price
      t.string     :location
      t.references :user

      t.timestamps
    end
  end
end
