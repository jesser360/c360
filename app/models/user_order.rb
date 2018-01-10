class UserOrder < ApplicationRecord
  belongs_to :user
  belongs_to :bulk_order, optional: true
end
