class Charge < ApplicationRecord
  belongs_to :user
  belongs_to :product

  after_create :send_email
  
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
        destination: product.user.uid
      })
      response[:status] = 200
      Charge.create(user: user, product: product, response: charge)
    rescue Stripe::CardError, Stripe::InvalidRequestError => e
      error = e.json_body[:error][:message]
      response[:status] = 500
      response[:error] = "Sorry! #{error}"
    end
    response
  end

  def send_email
    ChargesMailer
      .successful_charge(self)
      .deliver
  end

end
