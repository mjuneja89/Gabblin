class Community < ActiveRecord::Base
	belongs_to :user
	has_many :relationships
	has_many :followers, through: :relationships, class_name: "User", :foreign_key => "favourite_id"
	has_many :posts, dependent: :destroy, :counter_cache => true
	validates :name, presence: true, uniqueness: true
    validates :description, presence: true
	mount_uploader :cpic, CpicUploader

	extend FriendlyId
    friendly_id :name, use: :slugged
       
 def self.search(search)
   if search	
 	Community.where("name ILIKE ?", "%#{search}%")
   end
 end
    
end
