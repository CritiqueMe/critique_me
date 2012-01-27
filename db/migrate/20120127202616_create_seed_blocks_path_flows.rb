class CreateSeedBlocksPathFlows < ActiveRecord::Migration
  def change
    create_table :path_flows do |t|
      t.integer :experiment_id
      t.string :flow
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
