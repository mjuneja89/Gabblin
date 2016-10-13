class Heart < ActiveRecord::Base
	belongs_to :user
	belongs_to :post, :counter_cache => true
	belongs_to :comment, :counter_cache => true
	belongs_to :reply, :counter_cache => true
end
