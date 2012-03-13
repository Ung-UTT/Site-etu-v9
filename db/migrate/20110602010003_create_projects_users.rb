class CreateProjectsUsers < ActiveRecord::Migration
  def change
    create_table :projects_users do |t|
      t.references :project
      t.references :user

      t.timestamps
    end
  end
end
