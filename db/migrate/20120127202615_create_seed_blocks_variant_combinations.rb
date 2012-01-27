class CreateSeedBlocksVariantCombinations < ActiveRecord::Migration
  def change
    create_table :variant_combinations do |t|
      t.integer :experiment_id
      t.integer :path_flow_id
      t.string :key
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
