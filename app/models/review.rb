class Review < ApplicationRecord
  belongs_to :user
  belongs_to :item
  belongs_to :bulk_order,optional:true
  belongs_to :user_order,optional:true
end
