class RemoveOrderItemFromBulkOrder < ActiveRecord::Migration[5.1]
  def change
    remove_reference :bulk_orders, :order_item, foreign_key: true
  end
end
