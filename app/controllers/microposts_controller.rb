class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
       if (@micropost.content.first == '@')
		  index = @micropost.content.index(" ")
          index.nil? ? target_user =  0 : 
					   target_user = @micropost.content.at(1..(index-1))
		  user = User.find_by_username(target_user) 
		  user.nil? ?  @micropost.reply_to = 0 :
					   @micropost.reply_to = user.id
	   else
	   @micropost.reply_to = 0
	   end
	   @micropost.save
	   flash[:success] = "Micropost created"
	   redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

def destroy
    @micropost.destroy
    redirect_back_or root_path
  end

  private

    def authorized_user
      @micropost = Micropost.find(params[:id])
      redirect_to root_path unless current_user?(@micropost.user)
    end
end
