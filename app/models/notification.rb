class Notification < ActiveRecord::Base
	belongs_to :sender, :class_name => "User"
	belongs_to :receiver, :class_name => "User"
	belongs_to :post
	belongs_to :comment
end