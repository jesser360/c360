class AddCompletedToBulkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_orders, :completed, :boolean
  end
end
