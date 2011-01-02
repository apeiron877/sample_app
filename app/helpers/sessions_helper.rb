module SessionsHelper


  # signs the current user in, and creates a cookie
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end
  
  # signs the current user out of the system, and deletes the cookie
  def sign_out
	cookies.delete(:remember_token)
	current_user = nil
  end	
  
  # assigns the current_user local variable to input user
  def current_user=(user)
    @current_user = user
  end

  # sets the current_user local variable to the user from the token 
  # ONLY if the current_user local variable is nil
  def current_user 
	@current_user ||= user_from_remember_token
  end

  # returns true if the person accessing the system is signed in
  def signed_in?
	!current_user.nil?
  end
	
  # if the person accessing the system is not signed in, 
  # deny them access
  def authenticate
	deny_access unless signed_in?
  end

  # save the current location for friendly forwarding, and redirect
  # the person to the sign in page
  def deny_access
  store_location
  redirect_to signin_path, :notice => 
							"Please sign in to access this page."
  end
  
  # returns true if the current user is the input user
  def current_user?(user)
	user == current_user
  end
  
  # 
  def redirect_back_or(default)
	redirect_to(session[:return_to] || default)
	clear_return_to
  end


private

	def user_from_remember_token
		User.authenticate_with_salt(*remember_token)
	end
	
	def remember_token
		cookies.signed[:remember_token] || [nil,nil]
	end
	
	def store_location
	session[:return_to] = request.fullpath
	end
	
	def clear_return_to
	session[:return_to] = nil
	end
	
	
end	
			
