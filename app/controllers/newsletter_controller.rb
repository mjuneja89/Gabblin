class NewsletterController < ApplicationController
  
  before_action :require_admin

   def newsletter
   	@post = Post.find_by(id: 1397)
    User.find_each do |user|
      if user.subscribeflag == true && user.activated == true     
        SendNewsletterJob.set(wait: 20.seconds).perform_later(user, @post)
      end
    end  
    redirect_to '/'
  end

end
