class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :community
  has_many :transactions
  has_many :givers, through: :transactions, class_name: "User", :foreign_key => "receivingpost_id"
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

 def given?(user)
  Transaction.where(giver_id: user.id).where(receivingpost_id: self.id).present?
 end
    
 def fetchstuff
  @content = LinkThumbnailer.generate(self.link)
  self.linktitle = @content.title
  self.remote_linkphoto_url = @content.images.first.src.to_s
  self.save(:validate => false)
 end

 def postincrement
  self.increment!(:coin_count, 2)
 end

 def self.search(search)
  if search
      Post.where('title ILIKE ?', "%#{search}%")
    end
 end 

end

