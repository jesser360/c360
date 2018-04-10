class AddSupplierCodeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :supplier_code, :string
  end
end
