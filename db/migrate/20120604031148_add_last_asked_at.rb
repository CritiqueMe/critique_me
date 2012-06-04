class AddLastAskedAt < ActiveRecord::Migration
  def change
    add_column :default_questions, :last_asked_at, :datetime
  end
end
