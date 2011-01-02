class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate(:page => params[:page])
  end
  
  def new
    @title = "Sign up"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      sign_in @user
      redirect_to @user
	  
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end
  
  def edit
	@title = "Edit user"
	end
	
  def update
	if @user.update_attributes(params[:user])
		flash[:success] = "Profile updated."
		redirect_to @user
	else
	    @title = "Edit user"
		render 'edit'
	end
  end

  def index
	@title = "All users"
	@users = User.paginate(:page => params[:page])
	end
  
  def destroy
	@target = User.find(params[:id])
    if !current_user?(@target)
	  User.find(params[:id]).destroy
	  flash[:success] = "User deleted."
	  redirect_to users_path
	else
	  flash[:error] = "Admin users cannot delete themselves!"
	  redirect_to users_path
	end
  end

  def following	
	@user = User.find(params[:id])
	@title = "People #{@user.name} follows:"
	@users = @user.following.paginate(:page => params[:page])
	render 'show_follow'
  end
  
  def followers
	@user = User.find(params[:id])
	@title = "#{@user.name}'s followers:"
	@users = @user.followers.paginate(:page => params[:page])
	render 'show_follow'
  end
		
private 
  
	
  def correct_user
	@user = User.find(params[:id])
	redirect_to(root_path) unless current_user?(@user)
	end
	
  def admin_user
    if current_user.nil?
      redirect_to(signin_path)
    elsif !(current_user.admin?)
      redirect_to(root_path)
    end	
  end
end
