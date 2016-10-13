class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
 include SessionsHelper

  helper_method :current_user
  helper_method :linkconverter
  helper_method :render404

  def current_user
    current_user = User.find(session[:user_id]) if session[:user_id]
  end

  def linkconverter
    linkconverter = AutoHtml::Pipeline.new(AutoHtml::Link.new(target: '_blank'), AutoHtml::Image.new)
  end 

  def require_signin
    redirect_to "/signin" unless current_user
  end
 
  def require_admin
    error_path unless current_user.role == "admin"
  end

  def render404
    redirect_to "/404"
  end

  def correctuser
   @user = User.friendly.find(params[:id])
   render404 unless current_user.id == @user.id 
  end

  def store_return_to
    session[:return_to] = request.url
  end

  def immediateban
    if current_user.present? && current_user.banned?
      sign_out
      error_path
    end
  end

  def bancheck
    if current_user.present? && current_user.banned?
      sign_out
      render404
    else
      redirect_to "/"   
    end
  end

end
