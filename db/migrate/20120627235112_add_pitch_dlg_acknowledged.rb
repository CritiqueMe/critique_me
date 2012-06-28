class AddPitchDlgAcknowledged < ActiveRecord::Migration
  def change
    add_column :users, :pitch_dlg_acknowledged, :boolean, :default => false
  end
end
