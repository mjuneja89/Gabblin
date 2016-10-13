class Reply < ActiveRecord::Base
	belongs_to :comment
    belongs_to :user
	has_many :hearts
	validates :body, :presence => true

 def hearted?(user)
 	self.hearts.where(user_id: user.id).present?
 end

end
