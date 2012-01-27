class CreateSeedBlocksInviteFromLines < ActiveRecord::Migration
  def change
    create_table :invite_from_lines do |t|
      t.string :name
      t.boolean :active, :default => true
      t.boolean :reminder, :default => false
      t.string :from

      t.timestamps
    end
  end
end
