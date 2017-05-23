class ChargesMailer < ActionMailer::Base
  default from: 'rtcplatform@example.com'

  def successful_charge(charge)
    @charge = charge
    @user = @charge.user
    @product = @charge.product
    @response = ActiveSupport::JSON.decode(@charge.response)

    mail(to: @user.email,
         subject: 'Successful Charge')
  end

end
