json.extract! user_order, :id, :item, :user_id, :bulk_order_id, :created_at, :updated_at
json.url user_order_url(user_order, format: :json)
