class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string     :asset_file_name
      t.string     :asset_content_type
      t.integer    :asset_file_size
      t.datetime   :asset_updated_at
      t.references :documentable, :polymorphic => true
      t.string     :type # Pour Document/Image

      t.timestamps
    end

    add_index :documents, [:documentable_id, :documentable_type]
  end
end
