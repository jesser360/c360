class AddLowestPriceToBids < ActiveRecord::Migration[5.1]
  def change
    add_column :bids, :lowest_price, :integer
  end
end
