class OrderItem < ApplicationRecord
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :preserve_files => true
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :bulk_orders
  has_many :user_orders
  belongs_to :user
  belongs_to :item
end
