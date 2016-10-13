class SendNewsletterJob < ActiveJob::Base
  queue_as :default

 def perform(user, post)
  	@user = user
  	@post = post
    Mailer.newsletter_email(@user, @post).deliver_later
  end

end
