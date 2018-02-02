class AddBulkOrderAmountToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :bulk_order_amount, :integer
  end
end
