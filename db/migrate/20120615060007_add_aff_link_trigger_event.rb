class AddAffLinkTriggerEvent < ActiveRecord::Migration
  def change
    add_column :affiliate_links, :trigger_event, :string
    rename_column :affiliate_links, :signup_payout, :conversion_payout
  end
end
