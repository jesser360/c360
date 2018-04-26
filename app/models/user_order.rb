class UserOrder < ApplicationRecord
  belongs_to :user
  belongs_to :bulk_order, optional: true
  belongs_to :order_item

end
