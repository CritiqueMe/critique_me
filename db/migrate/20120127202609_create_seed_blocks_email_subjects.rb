class CreateSeedBlocksEmailSubjects < ActiveRecord::Migration
  def change
    create_table :email_subjects do |t|
      t.string :name
      t.string :email_type
      t.boolean :active, :default => true
      t.string :subject

      t.timestamps
    end
  end
end
