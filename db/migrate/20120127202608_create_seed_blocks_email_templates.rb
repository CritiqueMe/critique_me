class CreateSeedBlocksEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.string :name
      t.string :email_type
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
