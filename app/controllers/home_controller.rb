class HomeController < ApplicationController

before_action :store_return_to

def home
  redirect_to "/feed" if current_user
  @cover = Cover.order("RANDOM()").first
  @posts = Post.order(updated_at: :desc, created_at: :desc, comments_count: :desc).page(params[:page]).per(16) 
end

def insufficientcoins	
  respond_to :js
end

def insufficientpostcoins
  @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
end

end


