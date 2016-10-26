class Transaction < ActiveRecord::Base
	belongs_to :giver, class_name: "User"
	belongs_to :receivingpost, class_name: "Post"
	belongs_to :receivingcomment, class_name: "Comment"
end
