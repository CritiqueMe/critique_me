class CreateSeedBlocksUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :password_salt
      t.string :password_hash
      t.string :fb_user_id
      t.date :birthday
      t.integer :referrer_id
      t.string :referral_token
      t.string :country
      t.string :city
      t.string :zip
      t.text :about_me
      t.string :gender
      t.integer :affiliate_link_id
      t.string :affiliate_subid

      t.timestamps
    end
  end
end
