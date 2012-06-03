class AddLastFriendsUpdateToUser < ActiveRecord::Migration
  def change
    add_column :users, :friends_updated_at, :timestamp
    add_column :users, :fb_pic_square, :text
  end
end
