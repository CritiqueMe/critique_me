class AddUsampIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :usamp_id, :integer
  end
end
