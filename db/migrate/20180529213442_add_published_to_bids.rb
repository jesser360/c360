class AddPublishedToBids < ActiveRecord::Migration[5.1]
  def change
    add_column :bids, :published, :boolean
  end
end
