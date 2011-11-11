class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string       :name
      t.text         :description
      t.string       :location
      t.datetime     :start_at
      t.datetime     :end_at
      t.references   :owner

      t.timestamps
    end
  end
end
