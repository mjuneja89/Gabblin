class CommentsController < ApplicationController
  
  before_action :require_signin, only: [:create, :heartc, :unheartc]
  before_action :assigncomment, only: [:createresponse]
  before_action :correctuser2, only: [:edit, :update, :destroy]
  before_action :store_return_to, only: [:show]
 
  def create
   
   if current_user.coin_count > 1

    @post = Post.friendly.find(params[:post_id])
    
    @comment = current_user.comments.build(comment_params) do |comment|
      comment.post = @post
    end
    
    current_user.commentcreatecurrency
    current_user.checklevel
    @post.update_attribute(:updated_at, Time.now)
     
    unless current_user == @post.user  
     @notification = Notification.create!(:sender_id => current_user.id, :receiver_id => @post.user.id, :post_id => @post.id, :category => "comment", :unread => true)
     SendEmailJob.set(wait: 40.seconds).perform_later(@post, current_user, @post.user)
    end

    @comments = @post.comments.order(created_at: :desc)

    if @comment.save
      respond_to :js
    else
      redirect_to @post
    end
   
   else
      redirect_to insufficientcoins_path
   end    
  end

 def createresponse
  
  if current_user.coin_count > 1

   @response = current_user.comments.build(comment_params) do |response|
     response.parent = @comment
   end

   current_user.commentcreatecurrency
   current_user.checklevel

   if @comment.post.present?
  	 @comment.post.update_attribute(:updated_at, Time.now)
   end

   unless current_user == @comment.user  
     @notification = Notification.create!(:sender_id => current_user.id, :receiver_id => @comment.user.id, :comment_id => @comment.id, :category => "response", :unread => true)
     SendResponseJob.set(wait: 40.seconds).perform_later(@comment, current_user, @comment.user)   
   end

   @responses = @comment.responses.order(created_at: :desc)

   if @response.save
     respond_to :js
   else
     redirect_to @comment
   end

 else
    redirect_to insufficientcoins_path
 end 
 
 end  

def destroy
  @comment =  Comment.find(params[:id])
  @post = @comment.post
  @community = @post.community
   if @comment.parent.present?
     @parent = @comment.parent
     @comment.destroy
     redirect_to comment_path(@parent)
   else
     @comment.destroy
     redirect_to community_post_path(@community, @post)
   end 
end

#Give Coins Starts

def givecommentcoins
  @comment = Comment.find(params[:comment_id])
  @user = @comment.user
  current_user.commentgivecurrency
  @user.commentreceivecurrency
  respond_to :js
end   
   
#Give Coins Ends

#Comment Heart Functionality Starts

  def heartc
    @comment = Comment.find(params[:comment_id])
    @post = @comment.post
    @heart = @comment.hearts.build(:comment_id => @comment.id) do |heart|
      heart.user = current_user
    end
    if @heart.save
      @comment.reload
      respond_to :js
    end
  end

  def unheartc
    @comment = Comment.find(params[:comment_id])
    @post = @comment.post
    @heart = @comment.hearts.where(user_id: current_user.id)
    Heart.destroy(@heart)
    @comment.reload
    respond_to :js
  end

#Comment Heart Functionality Ends

def edit
  @comment = Comment.find(params[:id])
  respond_to :js
end

def update
  @comment = Comment.find(params[:id])
  if @comment.update_attributes(comment_params)
    redirect_to @comment
  end
end 
  
def show
  @comment = Comment.find(params[:id])
  @responses = @comment.responses.order(:created_at).page(params[:page]).per(10)
  if current_user
   @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
  end
end

private

  def comment_params
    params.require(:comment).permit(:parent_id, :body)
  end

  def correctuser2
    @comment = Comment.find(params[:id])
    @user = @comment.user
    unless current_user.id == @user.id || current_user.role == "admin"
      render404
    end
  end

  def assigncomment
    @comment = Comment.find(params[:comment_id])
  end

end
