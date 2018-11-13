class Account < ActiveRecord::Base
  has_secure_password
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_uniqueness_of :handle
  validates_uniqueness_of :email
  validates :password_digest, :length => {:within => 6..60}
  has_attached_file :image, styles: { large:"600x600>", medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
