class SitemapsController < ApplicationController
  
  def index
    @static_pages = [root_url]

    @posts = Post.all
    @users = User.all
    
    respond_to do |format|
      format.xml
    end
  end

end
