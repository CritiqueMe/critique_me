class CreateSeedBlocksAdminUsers < ActiveRecord::Migration
  def change
    create_table :admin_users do |t|
      t.string :email
      t.string :password_salt
      t.string :password_hash
      t.string :first_name
      t.string :last_name
      t.integer :role

      t.timestamps
    end
  end
end
