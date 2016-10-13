class SendEmailJob < ActiveJob::Base
  queue_as :default

  def perform(post, sender, receiver)
  	@post = post
  	@sender = sender
  	@receiver = receiver
  	Mailer.notification_comment(@post, @sender, @receiver).deliver_later
  end
  
end
