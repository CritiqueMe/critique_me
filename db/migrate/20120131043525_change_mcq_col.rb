class ChangeMcqCol < ActiveRecord::Migration
  def change
    remove_column :multiple_choice_options, :default_multiple_choice_question_id
    add_column :multiple_choice_options, :default_multiple_choice_option_id, :integer
  end
end
