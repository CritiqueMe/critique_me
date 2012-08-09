class AddAddressFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address1, :string
    add_column :users, :address2, :string
    add_column :users, :state, :string
  end
end
