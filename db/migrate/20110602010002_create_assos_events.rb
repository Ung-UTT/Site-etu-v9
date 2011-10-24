class CreateAssosEvents < ActiveRecord::Migration
  def self.up
    create_table :assos_events, :id => false do |t|
      t.references :asso
      t.references :event

      t.timestamps
    end
  end

  def self.down
    drop_table :assos_events
  end
end
