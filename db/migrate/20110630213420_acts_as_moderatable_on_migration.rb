class ActsAsModeratableOnMigration < ActiveRecord::Migration
  def self.change
    add_column :news, :is_moderated, :boolean
  end
end

