class Comment < ActiveRecord::Base
   belongs_to :post, :counter_cache => true
   belongs_to :user
   has_many :hearts
   belongs_to :parent, :class_name => "Comment" 
   has_many :responses, :class_name => "Comment", foreign_key: :parent_id, dependent: :destroy
   validates :body, :presence => true
   has_many :notifications, dependent: :destroy
   has_many :replies, dependent: :destroy


 def hearted?(user)
 	self.hearts.where(user_id: user.id).present?
 end
   
end
