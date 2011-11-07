class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :question
      t.references :user

      t.timestamps
    end
    add_index :votes, :question_id
    add_index :votes, :user_id
  end
end
