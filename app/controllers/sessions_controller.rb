class SessionsController < ApplicationController
    
    def new
    end

    def new1
    end

    def create
        @user = User.find_by_email(params[:session][:email])
        if @user && @user.authenticate(params[:session][:password])
           if @user.activated == true 
            sign_in @user
            redirect_to session.delete(:return_to)
           else
            redirect_to user_activate_path(@user)
           end  
        else
            flash.now[:danger] = "invalid email or password"
            render 'new'
        end
    end

    def destroy
       sign_out(current_user)
       redirect_to "/"
    end 

end