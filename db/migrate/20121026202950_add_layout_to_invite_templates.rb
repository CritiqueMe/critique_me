class AddLayoutToInviteTemplates < ActiveRecord::Migration
  def change
    add_column :invite_templates, :layout, :string
  end
end
