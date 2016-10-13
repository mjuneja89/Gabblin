class FeedController < ApplicationController
  
  before_action :require_signin

  def feed
    @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
    @relationships = Relationship.where(:follower_id => current_user.id)
    post_ids = []
    if @relationships.any?
       @relationships.each do |relationship|
        post_ids << relationship.favourite.posts.all.map(&:id)
       end   
      @posts = Post.where(id: post_ids).order(updated_at: :desc, created_at: :desc).page(params[:page]).per(16)
    else
      @posts = Post.order(updated_at: :desc, created_at: :desc).page(params[:page]).per(16)
    end
  end
  
end