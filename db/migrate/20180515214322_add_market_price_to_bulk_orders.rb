class AddMarketPriceToBulkOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_orders, :market_price, :integer
    add_column :bulk_orders, :wholesale_price, :integer
    add_column :bulk_orders, :item_name, :string
  end
end
