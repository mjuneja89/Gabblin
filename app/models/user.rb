class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    has_secure_password
    validates :username, :presence => true, length: {maximum: 50}, :uniqueness => true
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, :presence => true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
    validates :password, :presence => true, length: {minimum: 6}, allow_nil: true
    mount_uploader :avatar, AvatarUploader
    has_many :posts, dependent: :destroy
    has_many :communities, dependent: :destroy
    has_many :hearts, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :replies, dependent: :destroy
    has_many :connections 
    has_many :fans, through: :connections, class_name: "User", :foreign_key => "idol_id" 
    has_many :idols, through: :connections, class_name: "User", :foreign_key => "fan_id"
    has_many :senders, through: :notifications, class_name: "User", :foreign_key => "sender_id"
    has_many :receivers, through: :notifications, class_name: "User", :foreign_key => "receiver_id"
    has_many :relationships
    has_many :favourites, through: :relationships, class_name: "Community", :foreign_key => "follower_id"
    
    extend FriendlyId
    friendly_id :username, use: :slugged
     

  def isafan?(user)
    Connection.where(fan_id: self.id).where(idol_id: user.id).present?
  end

def iscurrentuser? ( user )
   current_user.id == user.id
end

def hasfollowed?(community)
   Relationship.where(follower_id: self.id).where(favourite_id: community.id).present?
end

def passwordresetmail
   update_attribute(:password_reset_token, SecureRandom.hex(8))
   Mailer.password_reset(self).deliver_now
end

def activationmail
   update_attribute(:activation_token, SecureRandom.hex(8))
   SendWelcomeJob.set(wait: 20.seconds).perform_later(self)      
end

def subscribefeature
   update_attribute(:unsubscribe_token, SecureRandom.hex(8))
end

def checklevel
 if self.points > 100 && self.points < 500
    update_attribute(:level, "Great Gabblin")
 elsif self.points > 499 && self.points < 2000
    update_attribute(:level, "Grand Gabblin")
 elsif self.points > 1999 && self.points < 10000
    update_attribute(:level, "Seasoned Gabblin")     
 elsif self.points > 9999
    update_attribute(:level, "Veteran Gabblin")
 else
    update_attribute(:level, "Fresh Gabblin")    
end
end 

def banuser
    update_attribute(:banflag, true)
    self.posts.destroy_all
end

def unbanuser
    update_attribute(:banflag, false)
end


def banned?
    self.banflag == true
end

def unsubscribe
    update_attribute(:subscribeflag, false) 
end

end
