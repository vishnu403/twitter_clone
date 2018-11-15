class Like < ActiveRecord::Base
  belongs_to :account
  validates_uniqueness_of :tweet_id, scope: :account_id
end
