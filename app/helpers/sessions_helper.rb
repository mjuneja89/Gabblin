module SessionsHelper
	
def sign_in(user)
	session[:user_id] = user.id
end

def sign_out(user)
	session.delete(:user_id)
	current_user = nil
end

end
