class AddFbIdsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :fb_question_id, :string
    add_column :answers, :fb_answer_id, :string
  end
end
