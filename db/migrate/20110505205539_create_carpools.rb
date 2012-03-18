class CreateCarpools < ActiveRecord::Migration
  def change
    create_table :carpools do |t|
      t.text        :description
      t.string      :departure
      t.string      :arrival
      t.datetime    :date
      t.boolean     :is_driver
      t.references  :user

      t.timestamps
    end
  end
end
