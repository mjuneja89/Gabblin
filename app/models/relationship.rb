class Relationship < ActiveRecord::Base
	belongs_to :follower, class_name: "User"
	belongs_to :favourite, class_name: "Community"
end