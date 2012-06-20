class CreateOrderHistory < ActiveRecord::Migration
  def change
    create_table :order_history do |t|
      t.integer :user_id, :null => false
      t.integer :order_package, :null => false
      t.integer :fb_credit_amount, :null => false, :default => 0
      t.integer :our_credit_amount, :null => false, :default => 0

      t.timestamps
    end
  end
end


