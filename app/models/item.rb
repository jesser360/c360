class Item < ApplicationRecord
  has_many :bulk_orders
  belongs_to :user
end
