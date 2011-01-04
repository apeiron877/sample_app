module UsersHelper

# Needs Gravatar Gem
#  def gravatar_for(user, options = { :size => 50 })
#    gravatar_image_tag(user.email.downcase, :alt => user.name,
#                                            :class => 'gravatar',
#                                            :gravatar => options)
#  end
#end

def avatar_url(user,size)
	# not working  \default_url = "public/images/guest.png"
	gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
	"http://gravatar.com/avatar/#{gravatar_id}.png?s=#{h(size)}&d=mm"
  end
end
