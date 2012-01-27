class CreateSeedBlocksInviteTemplates < ActiveRecord::Migration
  def change
    create_table :invite_templates do |t|
      t.string :name
      t.boolean :active, :default => true
      t.boolean :reminder, :default => false

      t.timestamps
    end
  end
end
