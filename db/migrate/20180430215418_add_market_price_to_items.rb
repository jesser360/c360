class AddMarketPriceToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :market_price, :integer
  end
end
