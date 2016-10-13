class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :community
  has_many :hearts, dependent: :destroy
  validates :title, :presence => true
  has_many :notifications, dependent: :destroy 

  mount_uploader :linkphoto, LinkphotoUploader
  mount_uploader :image, ImageUploader

  extend FriendlyId
  friendly_id :title, use: :slugged

 def hearted?(user)
  self.hearts.where(user_id: user.id).present?
 end    
    
 def fetchstuff
  @content = LinkThumbnailer.generate(self.link)
  self.linktitle = @content.title
  self.remote_linkphoto_url = @content.images.first.src.to_s
  self.save(:validate => false)
 end

 def self.search(search)
  if search
      Post.where('title ILIKE ?', "%#{search}%")
    end
 end 

end

