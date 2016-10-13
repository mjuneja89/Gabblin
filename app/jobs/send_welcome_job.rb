class SendWelcomeJob < ActiveJob::Base
   
   queue_as :default

   def perform(user)
  	 @user = user
  	 Mailer.newuser(@user).deliver_later
   end

end
