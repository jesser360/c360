class User < ApplicationRecord
  has_many :user_orders
  has_and_belongs_to_many :bulk_orders
  has_secure_password
  has_many :items
end
