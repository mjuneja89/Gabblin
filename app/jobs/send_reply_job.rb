class SendReplyJob < ActiveJob::Base
  queue_as :default
  
  def perform(post, sender, receiver)
  	@post = post
    @sender = sender
    @receiver = receiver
    Mailer.notification_reply(@post, @sender, @receiver).deliver_later 
  end

end
