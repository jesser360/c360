require "administrate/base_dashboard"

class UserOrderDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    bulk_order: Field::BelongsTo,
    id: Field::Number,
    item: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    quantity: Field::Number,
    expiration: Field::Number,
    total_price: Field::Number,
    charge_token: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :user,
    :item,
    :quantity,
    :total_price,
    :charge_token,
    :bulk_order,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :bulk_order,
    :id,
    :item,
    :created_at,
    :updated_at,
    :quantity,
    :expiration,
    :total_price,
    :charge_token,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :bulk_order,
    :item,
    :quantity,
    :expiration,
    :total_price,
    :charge_token,
  ].freeze

  # Overwrite this method to customize how user orders are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user_order)
  #   "UserOrder ##{user_order.id}"
  # end
end
