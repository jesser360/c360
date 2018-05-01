class AddMarketPriceToOrderItems < ActiveRecord::Migration[5.1]
  def change
    add_column :order_items, :market_price, :integer
  end
end
