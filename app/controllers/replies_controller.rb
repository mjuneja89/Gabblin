class RepliesController < ApplicationController
 
  before_action :require_signin
  before_action :correctuser3, only: [:edit, :update, :destroy]
  

  def create
     @comment = Comment.find(params[:comment_id])
     @post = @comment.post
    

     @reply = current_user.replies.build(reply_params) do |reply|
       reply.comment = @comment
     end
    
     current_user.increment!(:points, 2)
     current_user.checklevel

     unless current_user == @comment.user
     @notification = Notification.create!(:sender_id => current_user.id, :receiver_id => @comment.user.id, :comment_id => @comment.id, :category => "reply", :unread => true)
     SendReplyJob.set(wait: 40.seconds).perform_later(@post, current_user, @comment.user)
     end

     @replies = @comment.replies.order(created_at: :desc)
       
     if @reply.save
       respond_to :js
     else
       redirect_to @comment
     end
  end

def mention
  @reply = Reply.find(params[:reply_id])
  @comment = @reply.comment
  @user = @reply.user
  respond_to :js
end

def destroy
  @reply = Reply.find(params[:id])
  @comment = @reply.comment
  @post = @comment.post
  @community = @post.community
  @reply.destroy
  redirect_to community_post_path(@community, @post)
end

#Reply Heart Functionality Starts

  def heartr
    @reply = Reply.find(params[:reply_id])
    @comment = @reply.comment
    @heart = @reply.hearts.build(:reply_id => @reply.id) do |heart|
      heart.user = current_user
    end
    if @heart.save
      @reply.reload
      respond_to :js
    end
  end

  def unheartr
    @reply = Reply.find(params[:reply_id])
    @comment = @reply.comment
    @heart = @reply.hearts.where(user_id: current_user.id)
    @reply.reload
    Heart.destroy(@heart)
    respond_to :js
  end

def edit
  @comment = Comment.find(params[:comment_id])
  @reply = Reply.find(params[:id])
  respond_to :js
end

def update
  @comment = Comment.find(params[:comment_id])
  @reply = Reply.find(params[:id])
  @replies = @comment.replies.order(created_at: :desc)
  if @reply.update_attributes(reply_params)
    respond_to :js
  end
end  

private
   def reply_params
   	params.require(:reply).permit(:body)
   end

  def correctuser3
    @comment = Comment.find(params[:comment_id])
    @reply = Reply.find(params[:id])
    @user = @reply.user
    unless current_user.id == @user.id || current_user.role == "admin"
      render404
    end
  end

end
