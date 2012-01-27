class CreateSeedBlocksPathElements < ActiveRecord::Migration
  def change
    create_table :path_elements do |t|
      t.integer :path_spot_id
      t.integer :path_element_group_id
      t.string :name
      t.boolean :active, :default => true
      t.text :html

      t.timestamps
    end
  end
end
