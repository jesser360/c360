class Review < ApplicationRecord
  belongs_to :user
  belongs_to :item
  belongs_to :bulk_order
end
