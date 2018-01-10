class CreateBulkOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :bulk_orders do |t|
      t.integer :percent_filled
      t.integer :expiration
      t.string :item

      t.timestamps
    end
  end
end
