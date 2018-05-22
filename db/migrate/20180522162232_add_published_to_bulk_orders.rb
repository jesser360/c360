class AddPublishedToBulkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_orders, :published, :boolean
  end
end
