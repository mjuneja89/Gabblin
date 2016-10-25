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

def postcreatecurrency
    self.decrement_counter(:coin_count, 5)
    self.increment_counter(:spent_coins, 5)
end

def postgivecurrency
    self.decrement_counter(:coin_count, 2)
    self.increment_counter(:spent_coins, 2)
end

def postreceivecurrency
    self.increment_counter(:coin_count, 2)
end

def commentcreatecurrency
    self.decrement_counter(:coin_count, 2)
    self.increment_counter(:spent_coins, 2)
end

def commentgivecurrency
    self.decrement_counter(:coin_count, 1)
    self.increment_counter(:spent_coins, 1)
end

def commentreceivecurrency
    self.increment_counter(:coin_count, 1)
end

def checklevel
 if self.spent_coins > 10 && self.spent_coins < 25
    update_attribute(:level, "Level 2")
 end   
 if self.spent_coins > 25 && self.spent_coins < 55
    update_attribute(:level, "Level 3")
 end   
 if self.spent_coins > 55 && self.spent_coins < 105
    update_attribute(:level, "Level 4")
 end        
 if self.spent_coins > 105 && self.spent_coins < 180
    update_attribute(:level, "Level 5")
 end   
 if self.spent_coins > 180 && self.spent_coins < 280
    update_attribute(:level, "Level 6")
 end   
 if self.spent_coins > 280 && self.spent_coins < 430
    update_attribute(:level, "Level 7")
 end   
 if self.spent_coins > 430 && self.spent_coins < 770
    update_attribute(:level, "Level 8")
 end   
 if self.spent_coins > 770 && self.spent_coins < 1270
    update_attribute(:level, "Level 9")
 end       
 if self.spent_coins > 1270
    update_attribute(:level, "Level 10")    
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
