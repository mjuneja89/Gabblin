class PostsController < ApplicationController

 before_action :require_signin, only: [:new, :create, :heart, :unheart, :search]
 before_action :correctuser1, only: [:edit, :update, :destroy]
 before_action :store_return_to, only: [:show]

 
 def search
   @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
   if params[:search] 
     @posts = Post.search(params[:search]).page(params[:page]).per(12)
   end
 end 

 def new
  @community = Community.friendly.find(params[:community_id])
  @post = Post.new  
  @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
 end  
 
 def create
  @community = Community.friendly.find(params[:community_id])
  
  @post = current_user.posts.build(post_params) do |post|
    
    post.community = @community
  
  end
   
   if @post.link.present?
     @post.fetchstuff
   end

   current_user.increment!(:points, 20)
   current_user.checklevel 
   
   if @post.save
    redirect_to @post.community
   else
      render 'new'
   end
 end

 def show
  @community = Community.friendly.find(params[:community_id])
  @post = Post.friendly.find(params[:id])
  @comments = @post.comments.order(hearts_count: :desc).page(params[:page]).per(10)
  if current_user
    @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
  end
 end

 def edit
  @community = Community.friendly.find(params[:community_id])
  @post = Post.friendly.find(params[:id])
  @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
end

def update
  @community = Community.friendly.find(params[:community_id])
  @post = Post.friendly.find(params[:id])
  if @post.update_attributes(post_params)
    redirect_to community_post_path(@community, @post)
  else
    render 'edit'
  end
end

def destroy
  @community = Community.friendly.find(params[:community_id])
  @post = Post.friendly.find(params[:id])
  Post.destroy(@post)
  redirect_to '/feed'
end

 def heart
  @post = Post.friendly.find(params[:post_id])
  @community = @post.community
  @heart = @post.hearts.build(:post_id => @post.id) do |heart|
    heart.user = current_user
  end
  if @heart.save
    @post.reload
    respond_to :js
  end
 end

 def unheart
  @post = Post.friendly.find(params[:post_id])
  @community = @post.community
  @heart = @post.hearts.where(user_id: current_user.id)
  Heart.destroy(@heart)
  @post.reload
  respond_to :js
 end

private

def post_params
  params.require(:post).permit(:title, :description, :link, :image)
end

def correctuser1
  @community = Community.friendly.find(params[:community_id])
  @post = Post.friendly.find(params[:id])
  @user = @post.user
  unless current_user.id == @user.id || current_user.role == "admin"
    render404
  end
end

end
