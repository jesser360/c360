class Bid < ApplicationRecord
  belongs_to :supplier, :class_name => 'User', optional:true
  belongs_to :buyer, :class_name => 'User'
  has_many :bid_offers
end
