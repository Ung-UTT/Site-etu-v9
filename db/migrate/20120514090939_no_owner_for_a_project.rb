class NoOwnerForAProject < ActiveRecord::Migration
  def change
    remove_column :projects, :owner
    add_index :projects, :name
  end
end
