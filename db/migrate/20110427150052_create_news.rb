class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string     :title
      t.text       :content
      t.references :user
      t.references :event
      t.boolean    :is_moderated

      t.timestamps
    end

    add_index :news, :user_id
    add_index :news, :event_id
  end
end
