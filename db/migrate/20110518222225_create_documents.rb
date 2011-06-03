class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string     :asset_file_name
      t.string     :asset_content_type
      t.integer    :asset_file_size
      t.datetime   :asset_updated_at
      t.references :documentable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
