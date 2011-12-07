class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string     :content
      t.references :poll

      t.timestamps
    end
  end
end
