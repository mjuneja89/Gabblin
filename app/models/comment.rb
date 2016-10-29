class Comment < ActiveRecord::Base
   belongs_to :post, :counter_cache => true
   belongs_to :user
   has_many :hearts
   has_many :transactions
   has_many :givers, through: :transactions, class_name: "User", :foreign_key => "receivingcomment_id"
   belongs_to :parent, :class_name => "Comment" 
   has_many :responses, :class_name => "Comment", foreign_key: :parent_id, dependent: :destroy
   validates :body, :presence => true
   has_many :notifications, dependent: :destroy
   has_many :replies, dependent: :destroy


 def hearted?(user)
 	self.hearts.where(user_id: user.id).present?
 end

 def given?(user)
   Transaction.where(giver_id: user.id).where(receivingcomment_id: self.id).present?
 end

 def commentincrement
  self.increment!(:coin_count, 1)
 end
   
end
