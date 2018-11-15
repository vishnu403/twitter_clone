class Account < ActiveRecord::Base
  has_many :tweets
  has_secure_password
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_uniqueness_of :handle
  validates_uniqueness_of :email
  validates :password_digest, :length => {:within => 6..60}
  has_attached_file :image, styles: { large:"600x600>", medium: "300x300>", thumb: "100x100>" }
  # validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def get_tweet_count()
    get_tweets_by_user(id)
  end

  def get_tweets_by_user(user_id)
    Account.joins(:tweets).where("tweets.account_id = #{user_id}").count
  end
end
