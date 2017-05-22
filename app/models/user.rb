class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable


  has_many :products
  has_many :charges

  def self.omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = SecureRandom.hex
      user.access_code = auth.credentials.token
      user.publishable_key = auth.info.stripe_publishable_key
    end
  end

end
