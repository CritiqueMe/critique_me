class CreateSeedBlocksEmailFromLines < ActiveRecord::Migration
  def change
    create_table :email_from_lines do |t|
      t.string :name
      t.string :email_type
      t.boolean :active, :default => true
      t.string :from

      t.timestamps
    end
  end
end
