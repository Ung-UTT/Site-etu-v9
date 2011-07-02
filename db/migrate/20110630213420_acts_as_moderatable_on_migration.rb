class ActsAsModeratableOnMigration < ActiveRecord::Migration
  def self.up
    add_column :news, :is_moderated, :boolean
  end

  def self.down
    remove_column :is_moderated
  end
end

