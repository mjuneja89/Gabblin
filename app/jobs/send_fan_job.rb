class SendFanJob < ActiveJob::Base
  queue_as :default
  
  def perform(idol)
  	@idol = idol
  	Mailer.notification_fan(@idol).deliver_later
  end
  
end
