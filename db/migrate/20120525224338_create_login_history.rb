class CreateLoginHistory < ActiveRecord::Migration
  def change
    create_table :login_history do |t|
      t.integer :user_id, :null => false
      t.date    :login_date, :null => false
      t.string  :login_year_month, :null => false

      t.timestamps
    end
  end
end
