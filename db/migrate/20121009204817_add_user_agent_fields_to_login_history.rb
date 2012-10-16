class AddUserAgentFieldsToLoginHistory < ActiveRecord::Migration
  def change
    add_column :login_history, :os_name, :string
    add_column :login_history, :os_major_version, :string
    add_column :login_history, :os_minor_version, :string
    add_column :login_history, :browser_name, :string
    add_column :login_history, :browser_major_version, :string
    add_column :login_history, :browser_minor_version, :string
    add_column :login_history, :platform, :string
    add_column :login_history, :is_mobile, :boolean
  end
end
