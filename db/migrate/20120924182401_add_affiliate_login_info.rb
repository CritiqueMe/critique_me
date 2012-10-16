class AddAffiliateLoginInfo < ActiveRecord::Migration
  def change
    add_column :affiliates, :email, :string
    add_column :affiliates, :password_salt, :string
    add_column :affiliates, :password_hash, :string
  end
end
