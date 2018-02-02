class AddIsVendorToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_vendor, :boolean
  end
end
