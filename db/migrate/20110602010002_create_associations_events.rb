class CreateAssociationsEvents < ActiveRecord::Migration
  def self.up
    create_table :associations_events, :id => false do |t|
      t.references :association
      t.references :event

      t.timestamps
    end
  end

  def self.down
    drop_table :associations_events
  end
end
