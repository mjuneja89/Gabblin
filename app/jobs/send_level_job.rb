class SendLevelJob < ActiveJob::Base
  queue_as :default

   def perform(user)
  	 @user = user
  	 Mailer.newlevel(@user).deliver_later
   end

end
