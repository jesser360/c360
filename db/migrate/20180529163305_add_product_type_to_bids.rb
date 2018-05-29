class AddProductTypeToBids < ActiveRecord::Migration[5.1]
  def change
    add_column :bids, :product_type, :string
    add_column :bids, :early_date, :date
    add_column :bids, :late_date, :date
    add_column :bids, :frequency, :string
    add_column :bids, :DEH_approved, :boolean
  end
end
