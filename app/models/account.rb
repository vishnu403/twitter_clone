class Account < ActiveRecord::Base
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_uniqueness_of :handle
  validates_uniqueness_of :email
  validates :password, :length => {:within => 6..40}
end
