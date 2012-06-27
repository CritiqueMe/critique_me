class AddEmailPreferences < ActiveRecord::Migration
  def change
    add_column :users, :email_preferences, :integer, :default => 0
  end
end
