class AddUserOrderToReviews < ActiveRecord::Migration[5.1]
  def change
    add_reference :reviews, :user_order, foreign_key: true
  end
end
