class Mailer < ApplicationMailer
  
  def newuser(user)
	  @user = user		
    mail(from: "Team Gabblin", to: user.email, subject: "Welcome to Gabblin!")
  end
  
  def password_reset(user) 
    @user = user
    mail(from: "Team Gabblin", to: user.email, subject: "Gabblin: Password Reset")
  end

  def newsletter_email(user, post)
  	@user = user
    @post = post
  	mail(from: "Team Gabblin", to: user.email, subject: "Should we smile at Strangers?")
  end

  def notification_comment(post, sender, receiver)
    @post = post
    @sender = sender
    @receiver = receiver
    mail(from: "Gabblin: Notifications", to: receiver.email, subject: "Someone responded to your post")
  end

  def notification_response(comment, sender, receiver)
    @comment = comment
    @sender = sender
    @receiver = receiver
    mail(from: "Gabblin: Notifications", to: receiver.email, subject: "Someone responded to your thought")
  end


  def notification_fan(idol)
    @idol = idol
    mail(from: "Gabblin: Notifications", to: idol.email, subject: "You have a new fan!")
  end    
  
  def newcoins(user)
    @user = user
    mail(from: "Gabblin: Notifications", to: @user.email, subject:"Claim your coins!")
  end

  def newlevel(user)
    @user = user
    mail(from: "Gabblin: Notifications", to: @user.email, subject:"You have just been promoted!")
  end

end
