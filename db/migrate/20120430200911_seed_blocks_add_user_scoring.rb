class SeedBlocksAddUserScoring < ActiveRecord::Migration
  def up
    add_column :users, :xp, :integer, :default => 0
    add_column :users, :level_id, :integer
    add_column :users, :karma_level_id, :integer
    add_column :users, :current_energy, :integer
    add_column :users, :energy_bucket_size, :integer
    add_column :users, :rank_score, :integer, :default => 0
  end

  def down
    remove_column :users, :xp
    remove_column :users, :level_id
    remove_column :users, :karma_level_id
    remove_column :users, :current_energy
    remove_column :users, :energy_bucket_size
    remove_column :users, :rank_score
  end
end
