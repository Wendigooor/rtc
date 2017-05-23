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
      notice =
        if charge[:status] == 200
          'Payment was successfully processed.'
        else
          charge[:error]
        end
      redirect_to products_url, notice: notice
    else
      redirect_to products_url
    end
  end

private
  
  def set_product
    @product = Product.find(params[:product_id])
  end

end
