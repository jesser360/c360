class User < ApplicationRecord
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :user_orders
  has_and_belongs_to_many :bulk_orders
  has_secure_password
  has_many :items
end
