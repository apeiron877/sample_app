# == Schema Information
# Schema version: 20110103213714
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  reply_to   :integer
#

class Micropost < ActiveRecord::Base
	attr_accessible :content
	
	belongs_to :user
	default_scope :order => 'microposts.created_at DESC'
	validates :content, :presence => true, :length => { :maximum => 140}
	validates :user_id, :presence => true

	# Return microposts from the users being followed by the given user
	scope :feed, lambda { |user| find_feed_posts(user) }
	



private
  
   def self.find_feed_posts(user)
	followed_user_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
                   
	posts_by_followed_users = self.where("user_id in (#{followed_user_ids})",
										{ :user_id => user }) 
    the_user =  self.where(:user_id => user.id)       
    replies =  self.where( :reply_to => (user.id)) 
    return posts_by_followed_users + the_user + replies
  end
end
