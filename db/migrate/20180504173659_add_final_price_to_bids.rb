class AddFinalPriceToBids < ActiveRecord::Migration[5.1]
  def change
    add_column :bids, :final_price, :integer
  end
end
