class AddRatingToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :rating, :integer
  end
end
