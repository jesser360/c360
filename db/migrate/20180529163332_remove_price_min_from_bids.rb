class RemovePriceMinFromBids < ActiveRecord::Migration[5.1]
  def change
    remove_column :bids, :price_min, :integer
  end
end
