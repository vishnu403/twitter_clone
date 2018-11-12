class Account < ActiveRecord::Base
  has_secure_password
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_uniqueness_of :handle
  validates_uniqueness_of :email
  validates :password_digest, :length => {:within => 6..60}
end
