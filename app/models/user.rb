class User < ApplicationRecord
  has_many :user_orders
  has_many :bulk_orders
  has_secure_password
end
