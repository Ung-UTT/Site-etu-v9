class CreateAssosEvents < ActiveRecord::Migration
  def change
    create_table :assos_events do |t|
      t.references :asso
      t.references :event

      t.timestamps
    end
  end
end
