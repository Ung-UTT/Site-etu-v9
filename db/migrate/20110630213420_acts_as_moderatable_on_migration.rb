class ActsAsModeratableOnMigration < ActiveRecord::Migration
  def change
    add_column :news, :is_moderated, :boolean
  end
end

