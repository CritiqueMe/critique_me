class CreateTwitterShareTemplates < ActiveRecord::Migration
  def change
    create_table :twitter_share_templates do |t|
      t.string :name
      t.string :message
      t.string :hashtags
      t.text :related_accounts
      t.boolean :active, :default => true
      t.timestamps
    end
  end
end
