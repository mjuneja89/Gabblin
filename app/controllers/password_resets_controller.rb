class PasswordResetsController < ApplicationController
  
  def new
  end

  def create
  	@user = User.find_by(email: params[:password_reset][:email])
  	@user.passwordresetmail if @user
  	respond_to :js
  end

 def edit
	@user = User.find_by_password_reset_token!(params[:id])
 end

 def update
 	@user = User.find_by_password_reset_token!(params[:id])
	if @user.update_attributes(user_params)
      redirect_to '/resetpasswordlogin'
	end
 end
 
 private

   def user_params
   	params.require(:user).permit(:password)
   end

end