class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :content
      t.references :pool

      t.timestamps
    end
    add_index :questions, :pool_id
  end
end
