class AddExperimentIdToTemplates < ActiveRecord::Migration
  def change
    add_column :invite_templates, :experiment_id, :integer
    add_column :fb_share_templates, :experiment_id, :integer
    add_column :twitter_share_templates, :experiment_id, :integer
  end
end
