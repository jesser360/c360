class AddPaidToBids < ActiveRecord::Migration[5.1]
  def change
    add_column :bids, :paid, :boolean
  end
end
