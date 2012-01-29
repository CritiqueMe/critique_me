class AddCritiqueMeTables < ActiveRecord::Migration
  def change
    add_column :users, :privacy_ask_questions, :integer, :default => 0

    # -------[ Biz Logic ]-------
    create_table :categories do |t|
      t.string :name
    end

    create_table :questions do |t|
      t.integer :user_id
      t.integer :question_type
      t.integer :default_question_id
      t.integer :category_id
      t.text :question_text
      t.string :photo
      t.timestamps
    end

    create_table :multiple_choice_options do |t|
      t.integer :question_id
      t.integer :default_multiple_choice_question_id
      t.text :answer_text
      t.timestamps
    end

    create_table :default_questions do |t|
      t.integer :category_id
      t.integer :questionnaire_id
      t.integer :question_type, :default => 0
      t.boolean :active, :default => true
      t.text :question_text
    end

    create_table :default_multiple_choice_options do |t|
      t.integer :default_question_id
      t.boolean :active, :default => true
      t.text :answer_text
    end

    create_table :questionnaires do |t|
      t.string :name
      t.boolean :active, :default => true
    end

    create_table :answers do |t|
      t.integer :user_id
      t.integer :question_id
      t.integer :multiple_choice_option_id
      t.boolean :true_false_answer
      t.text :open_text_answer
      t.timestamps
    end
  end
end
