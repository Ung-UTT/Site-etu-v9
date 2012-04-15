class CreateProjectsUsers < ActiveRecord::Migration
  def change
    create_table :projects_users do |t|
      t.references :project
      t.references :user

      t.timestamps
    end

    add_index :projects_users, :project_id
    add_index :projects_users, :user_id
  end
end
