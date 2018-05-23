class AddBulkOrderToReviews < ActiveRecord::Migration[5.1]
  def change
    add_reference :reviews, :bulk_order, foreign_key: true
  end
end
