class AddPublicPrivateToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :public, :boolean, :default => false
  end
end
