class CreateAssosEvents < ActiveRecord::Migration
  def change
    create_table :assos_events do |t|
      t.references :asso
      t.references :event

      t.timestamps
    end

    add_index :assos_events, :asso_id
    add_index :assos_events, :event_id
  end
end
