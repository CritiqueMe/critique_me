class CreateSeedBlocksPathSpots < ActiveRecord::Migration
  def change
    create_table :path_spots do |t|
      t.string :name
      t.integer :path_page_id

      t.timestamps
    end
  end
end
