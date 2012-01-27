class CreateSeedBlocksAffiliateLinks < ActiveRecord::Migration
  def change
    create_table :affiliate_links do |t|
      t.integer :affiliate_id
      t.string :url_token
      t.string :subid_param_name
      t.float :signup_payout, :default => 0.0
      t.string :pingback_url
      t.integer :experiment_id
      t.text :trigger_html

      t.timestamps
    end
  end
end
