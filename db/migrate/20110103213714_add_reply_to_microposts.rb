class AddReplyToMicroposts < ActiveRecord::Migration
  def self.up
    add_column :microposts, :reply_to, :integer
  end

  def self.down
    remove_column :microposts, :reply_to
  end
end
