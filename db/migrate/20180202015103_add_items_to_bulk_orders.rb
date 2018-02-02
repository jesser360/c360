class AddItemsToBulkOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :bulk_orders, :item, foreign_key: true
  end
end
