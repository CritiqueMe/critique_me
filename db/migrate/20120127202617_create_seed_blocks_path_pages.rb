class CreateSeedBlocksPathPages < ActiveRecord::Migration
  def change
    create_table :path_pages do |t|
      t.string :page_type
      t.string :name
      t.integer :experiment_id
      t.boolean :active, :default => true
      t.string :layout

      t.timestamps
    end
  end
end
