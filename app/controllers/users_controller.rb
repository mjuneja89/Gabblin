class UsersController < ApplicationController

  before_action :correctuser, only: [:edit, :update, :destroy, :claim]
   before_action :store_return_to, only: [:show]

  
  def new
    @user = User.new
  end

  def create
      @user = User.new(user_params)
      if @user.save
        @user.subscribefeature
        @user.activationmail
        redirect_to user_activate_path(@user) 
      else
        render 'new'
      end    
  end

  def destroy
    @user = User.friendly.find(params[:id])
    User.destroy(@user)
  end

  def show
    @user = User.friendly.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(16)
    if @user.level == "Level 1"
      @coinstobespent = 10
    elsif @user.level == "Level 2"
      @coinstobespent = 15
    elsif @user.level == "Level 3"
      @coinstobespent = 30
    elsif @user.level == "Level 4"
      @coinstobespent = 50
    elsif @user.level == "Level 5"
      @coinstobespent = 75
    elsif @user.level == "Level 6"
      @coinstobespent = 100
    elsif @user.level == "Level 7"
      @coinstobespent = 150
    elsif @user.level == "Level 8"
      @coinstobespent = 300
    else @user.level == "Level 9"
      @coinstobespent = 500
    end       
    if current_user
      @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
    end
  end

  def edit
    @user = User.friendly.find(params[:id])
    @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
  end

  def update
    @user = User.friendly.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def avatar
    @user = User.friendly.find(params[:user_id])
  end

  def updateavatar
    @user = User.friendly.find(params[:user_id])
    @user.update_attributes(user_params)
    @user.save(validate: false)
    redirect_to "/feed"
  end

  def notifications
    @user = User.friendly.find(params[:user_id])
    @proxies = Notification.where(:receiver_id => current_user.id).where(:unread => true)
    @notifications = Notification.where(:receiver_id => @user.id).order(created_at: :desc).page(params[:page]).per(10) 
    @notifications.each do |notification|
      notification.unread = false
      notification.save
    end 
  end

  def buildfeed
    @communities = Community.order(postcount: :desc)    
  end

  def followcommunities
    @communities = Community.order(postcount: :desc)    
  end

  def activate
  end
      
  def fan
       @user = User.friendly.find(params[:user_id])  
       @connection = Connection.create! do |connection|
          connection.fan = current_user
          connection.idol = @user
       end
       @notification = Notification.create!(:sender_id => current_user.id, :receiver_id => @user.id, :category => "fan", :unread => true)
       if @connection.save
         SendFanJob.set(wait: 40.seconds).perform_later(@user)
         respond_to :js
       end  
    end

   def unfan
      @user = User.friendly.find(params[:user_id])
      @connection = Connection.where(fan_id: current_user.id).where(idol_id: @user.id)
      Connection.delete(@connection)
      respond_to :js
   end 

   def claim
      @user = User.friendly.find(params[:user_id])
      @user.increment!(:coin_count, 20)
      @user.update_attribute(:coinstobeclaimed, 0)
      redirect_to @user
   end
    
    private
    
    def user_params
      params.require(:user).permit(:username, :email, :password, :oneliner, :avatar)
    end
    
end
