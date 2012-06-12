class AddMissingSbTables < ActiveRecord::Migration
  def up
    create_table :user_upgrades do |t|
      t.string :kind, :null=>false
      t.integer :amount, :null=>false
      t.string :bonuses
      t.timestamps
    end


  end

  def down
  end
end
