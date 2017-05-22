class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # def stripe_connect
  #     @user = User.omniauth(request.env["omniauth.auth"])
      
  #     if @user.persisted?
  #       sign_in_and_redirect @user
  #     else
  #       session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
  #       redirect_to new_user_registration_url
  #     end
  # end

  def stripe_connect
    omniauth_info = request.env["omniauth.auth"]
    @user = User.omniauth(omniauth_info)
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Stripe") if is_navigational_format?
    else
      session["devise.stripe_connect_data"] = omniauth_info
      redirect_to new_user_registration_url
    end
  end

end
