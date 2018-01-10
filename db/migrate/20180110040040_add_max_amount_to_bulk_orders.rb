class AddMaxAmountToBulkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_orders, :max_amount, :integer
  end
end
