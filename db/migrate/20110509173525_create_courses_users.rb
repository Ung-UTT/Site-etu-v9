class CreateCoursesUsers < ActiveRecord::Migration
  def self.up
    create_table :courses_users, :id => false do |t|
      t.integer :course_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :courses_users
  end
end
