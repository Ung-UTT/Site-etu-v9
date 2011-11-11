class CreateCourses < ActiveRecord::Migration
  def self.change
    create_table :courses do |t|
      t.string     :name
      t.text       :description

      t.timestamps
    end
  end
end
