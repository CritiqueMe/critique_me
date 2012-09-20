class AddCintIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cint_id, :integer
  end
end
