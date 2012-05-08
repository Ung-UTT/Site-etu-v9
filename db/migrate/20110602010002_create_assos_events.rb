class CreateAssosEvents < ActiveRecord::Migration
  def change
    create_table :assos_events, id: false do |t|
      t.references :asso
      t.references :event

      t.timestamps
    end

    add_index :assos_events, [ :asso_id, :event_id ]
  end
end
