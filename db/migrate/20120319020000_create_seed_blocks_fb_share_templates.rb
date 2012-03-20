class CreateSeedBlocksFbShareTemplates < ActiveRecord::Migration
  def change
    create_table :fb_share_templates do |t|
      t.string :name
      t.text :message
      t.string :link_display
      t.string :caption
      t.text :description
      t.boolean :active, :default => true
      t.timestamps
    end
  end
end
