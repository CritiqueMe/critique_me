class CreateCannedQuestions < ActiveRecord::Migration
  def change
    create_table :canned_questions do |t|
      t.text :text
      t.integer :num_choices
      t.integer :category_id
      t.boolean :active, :default => true
    end

    create_table :canned_question_choices do |t|
      t.integer :question_id
      t.string :friend_name
      t.string :friend_fb_id
    end

    add_column :questions, :canned_question_id, :integer
    add_column :answers, :canned_question_choice_id, :integer
  end
end
