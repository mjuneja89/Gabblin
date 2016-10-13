class EncyclopediaController < ApplicationController
  
  def vision
    if current_user
      @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
    end
  end

  def rules
    if current_user
      @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
    end
  end

  def careers
    if current_user
      @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
    end
  end

  def contact
    if current_user
      @notifications = Notification.where(:receiver_id => current_user.id).where(:unread => true)
    end
  end
     
end
