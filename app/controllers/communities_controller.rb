class CommunitiesController < ApplicationController

before_action :require_signin, only: [:index, :newpost, :search]
before_action :require_admin, only: [:new, :create, :edit, :update]
before_action :store_return_to, only: [:show]

def search
 @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true) 
 if params[:search] 
   @communities = Community.search(params[:search]).page(params[:page]).per(16)
 end
end

def index
  @communities = Community.all
  @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
end

def new
   @community = Community.new 
end

def create
   @community = Community.new(community_params)
   if @community.save
    redirect_to @community
   else
    render 'new'
   end
end

def show
  @community = Community.friendly.find(params[:id])
  @posts = @community.posts.order(updated_at: :desc, created_at: :desc).page(params[:page]).per(16)
  if current_user
    @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
  end
end

def edit
  @community = Community.friendly.find(params[:id])
end

def update
  @community = Community.friendly.find(params[:id])
  if @community.update_attributes(community_params)
    redirect_to @community
  end       
end

def destroy
  @community = Community.friendly.find(params[:id])
  Community.delete(@community)
  redirect_to "/"
end

def newpost
  @communities = Community.all.page(params[:page]).per(12)
  @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
end

def follow
  @community = Community.friendly.find(params[:community_id])
  @relationship = Relationship.create!(:follower_id => current_user.id, :favourite_id => @community.id)
  if @relationship.save
    respond_to :js
  end
end

def unfollow
  @community = Community.friendly.find(params[:community_id])
  @relationship = Relationship.where(:follower_id => current_user.id).where(:favourite_id => @community.id)
  Relationship.delete(@relationship)
  respond_to :js
end

private

def community_params
  params.require(:community).permit(:name, :description, :cpic)
end   

end
