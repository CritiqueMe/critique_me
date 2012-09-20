class AddFlagsToUser < ActiveRecord::Migration
  def change
    add_column :users, :flags, :integer, :default => 0
    remove_column :users, :email_verified
  end
end
