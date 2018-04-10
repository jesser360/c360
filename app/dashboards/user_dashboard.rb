require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user_orders: Field::HasMany,
    bulk_orders: Field::HasMany,
    items: Field::HasMany,
    id: Field::Number,
    company_name: Field::String,
    email: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    password_digest: Field::String,
    is_vendor: Field::Boolean,
    zipcode: Field::Number,
    city: Field::String,
    state: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :email,
    :company_name,
    :user_orders,
    :bulk_orders,
    :items,
    :city,
    :state,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user_orders,
    :bulk_orders,
    :items,
    :id,
    :company_name,
    :email,
    :created_at,
    :updated_at,
    :password_digest,
    :is_vendor,
    :zipcode,
    :city,
    :state,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user_orders,
    :bulk_orders,
    :items,
    :company_name,
    :email,
    :password_digest,
    :is_vendor,
    :zipcode,
    :city,
    :state,
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    user.email
  end
end
