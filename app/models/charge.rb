class Charge < ApplicationRecord
  belongs_to :user
  belongs_to :product

  
  def self.process_payment(user, token, product)
    amount = product.price * 100
    platform_fee = (amount.to_f / 10).to_i
    response = {}
    begin
      charge = Stripe::Charge.create({
        amount: amount.to_i,
        currency: "usd",
        source: token,
        description: "RTC charge: #{product.name}",
        application_fee: platform_fee,
        destination: user.uid
      })
      response[:status] = 200
      Charge.create(user: user, product: product, response: charge)

    rescue Stripe::CardError => e
      error = e.json_body[:error][:message]
      response[:status] = 500
      response[:error] = error
    rescue Stripe::InvalidRequestError => e
      error = e.json_body[:error][:message]
      response[:status] = 500
      response[:error] = error
    end
    response
  end

end
