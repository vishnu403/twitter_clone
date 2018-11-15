class Follower < ActiveRecord::Base
  belongs_to :account
  validates_uniqueness_of   :following_account_id, scope: :account_id
end
