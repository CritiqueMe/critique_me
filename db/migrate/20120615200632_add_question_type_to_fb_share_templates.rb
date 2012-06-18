class AddQuestionTypeToFbShareTemplates < ActiveRecord::Migration
  def change
    add_column :fb_share_templates, :question_type, :string
  end
end
