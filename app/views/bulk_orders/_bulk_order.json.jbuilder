json.extract! bulk_order, :id, :percent_filled, :expiration, :item, :created_at, :updated_at
json.url bulk_order_url(bulk_order, format: :json)
