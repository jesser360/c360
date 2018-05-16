class AddDescriptionToBulkOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_orders, :description, :string
  end
end
