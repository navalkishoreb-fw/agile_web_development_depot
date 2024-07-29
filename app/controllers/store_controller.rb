class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  skip_before_action :authorize

  def index
    if params[:set_locale]
      redirect_to store_index_url(locale: params[:set_locale])
    else
      @products = fetch_products
    end
  end

  def fetch_products
    Rails.cache.fetch("products", expires_in: 5.minutes) do
      Rails.logger.info("Cache miss for products")
      Product.order(:title).to_a
    end.tap do |products|
      Rails.logger.info("Cache hit for products") unless products.nil?
    end
  end

end
