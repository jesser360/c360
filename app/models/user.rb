class User < ApplicationRecord
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },:default_url => 'user-icon.png'
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :email, :presence => true, :uniqueness => true

  has_many :user_orders
  has_and_belongs_to_many :bulk_orders
  has_secure_password
  has_many :items
  has_many :order_items
  belongs_to :bid, optional: true
  has_many :bid_offers
  has_many :reviews
  has_secure_token

  def to_param
   token
  end
  
end
