class CreateSeedBlocksPathElementGroups < ActiveRecord::Migration
  def change
    create_table :path_element_groups do |t|
      t.integer :experiment_id
      t.string :name

      t.timestamps
    end
  end
end
