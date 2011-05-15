class CreateCoursesUsers < ActiveRecord::Migration
  def self.up
    create_table :courses_users, :id => false do |t|
      t.references :course
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :courses_users
  end
end
