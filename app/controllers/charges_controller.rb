class ChargesController < ApplicationController
  before_action :set_product, only: [:new, :create]

  def index
    @charges = current_user&.charges || []
  end

  def new

  end

  def create
    if @product && current_user && @product.user_id != current_user.id
      charge = Charge.process_payment(
        current_user,
        params[:stripeToken],
        @product
      )
      if charge[:status] == 200
        
      end
      redirect_to products_url
    else
      redirect_to products_url
    end
  end

private
  
  def set_product
    @product = Product.find(params[:product_id])
  end

end
