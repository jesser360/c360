class AddRatingCountToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :rating_count, :integer
  end
end
