class AddBuyerCountToBulkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_orders, :buyer_count, :integer
  end
end
