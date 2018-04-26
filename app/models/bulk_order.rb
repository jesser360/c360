class BulkOrder < ApplicationRecord
has_many :user_orders
has_and_belongs_to_many :users
belongs_to :item
belongs_to :order_item
attr_accessor :amount
end
