class UserActivateController < ApplicationController
   
  def edit
     @user = User.find_by_activation_token!(params[:id])
     @user.activated = true
     @user.save(validate: false)
     session[:user_id] = @user.id
     redirect_to user_followcommunities_path(@user)
  end

end
