class AddShareTypeToFbShareTemplates < ActiveRecord::Migration
  def change
    add_column :fb_share_templates, :share_type, :string, :default => 'newsfeed_post'
  end
end
