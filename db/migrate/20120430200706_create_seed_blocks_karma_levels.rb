class CreateSeedBlocksKarmaLevels < ActiveRecord::Migration
  def change
    create_table :karma_levels do |t|
      t.integer :level_num, :unique => true
      t.string :action
      t.integer :events_needed_per_day
      t.integer :days_needed
      t.timestamps
    end
  end
end
