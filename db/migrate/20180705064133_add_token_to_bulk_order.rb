class AddTokenToBulkOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :bulk_orders, :token, :string
    add_index :bulk_orders, :token, unique: true
  end
end
