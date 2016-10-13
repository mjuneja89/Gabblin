class SendResponseJob < ActiveJob::Base
  queue_as :default

  def perform(comment, sender, receiver)
  	@comment = comment
  	@sender = sender
  	@receiver = receiver
  	Mailer.notification_response(@comment, @sender, @receiver).deliver_later
  end
  
end
