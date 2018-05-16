class RemovePriceFromItem < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :price, :integer
    remove_column :items, :image, :string
    remove_column :items, :max_amount, :integer
    remove_column :items, :bulk_order_amount, :integer
    remove_column :items, :market_price, :integer
  end
end
