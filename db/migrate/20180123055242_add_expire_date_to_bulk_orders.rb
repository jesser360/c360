class AddExpireDateToBulkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_orders, :expire_date, :datetime
  end
end
