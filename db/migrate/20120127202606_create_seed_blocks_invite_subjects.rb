class CreateSeedBlocksInviteSubjects < ActiveRecord::Migration
  def change
    create_table :invite_subjects do |t|
      t.string :name
      t.boolean :active, :default => true
      t.boolean :reminder, :default => false
      t.string :subject

      t.timestamps
    end
  end
end
