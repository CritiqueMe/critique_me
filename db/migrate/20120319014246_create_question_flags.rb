class CreateQuestionFlags < ActiveRecord::Migration
  def change
    create_table :flagged_questions do |t|
      t.integer :question_id
      t.integer :user_id
      t.string :flag_reason
      t.text :message
      t.boolean :hidden, :default => false
      t.timestamps
    end
  end
end
