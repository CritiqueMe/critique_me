class AddPriorityToDefaultQuestions < ActiveRecord::Migration
  def change
    add_column :default_questions, :priority, :integer, :default => 0
    add_column :default_questions, :featured, :boolean, :default => false
  end
end
