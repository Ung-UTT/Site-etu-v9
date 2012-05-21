class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string     :name
      t.text       :description

      t.timestamps
    end

    add_index :projects, :name
  end
end
