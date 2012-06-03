class CreateSeedBlocksLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.integer :level_num, :unique => true
      t.integer :xp_requirement
      t.string :bonuses
      t.timestamps
    end
  end
end
