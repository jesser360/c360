class AddOrderItemToBulkOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :bulk_orders, :order_item, foreign_key: true
  end
end
