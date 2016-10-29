class SendNewcoinsJob < ActiveJob::Base
  queue_as :default

   def perform(user)
  	 @user = user
  	 Mailer.newcoins(@user).deliver_later
   end

end
