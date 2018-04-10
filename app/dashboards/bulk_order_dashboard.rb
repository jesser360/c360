require "administrate/base_dashboard"

class BulkOrderDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user_orders: Field::HasMany,
    users: Field::HasMany,
    item: Field::HasOne,
    id: Field::Number,
    percent_filled: Field::Number,
    expiration: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    max_amount: Field::Number,
    expire_date: Field::DateTime,
    completed: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :item,
    :user_orders,
    :users,
    :expire_date,
    :max_amount,
    :percent_filled
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user_orders,
    :users,
    :item,
    :id,
    :percent_filled,
    :expiration,
    :item,
    :created_at,
    :updated_at,
    :max_amount,
    :expire_date,
    :completed,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user_orders,
    :users,
    :item,
    :percent_filled,
    :expiration,
    :item,
    :max_amount,
    :expire_date,
    :completed,
  ].freeze

  # Overwrite this method to customize how bulk orders are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(bulk_order)
  #   "BulkOrder ##{bulk_order.id}"
  # end
end
