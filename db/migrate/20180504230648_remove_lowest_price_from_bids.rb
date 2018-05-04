class RemoveLowestPriceFromBids < ActiveRecord::Migration[5.1]
  def change
    remove_column :bids, :lowest_price, :integer
  end
end
