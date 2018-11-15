class Tweet < ActiveRecord::Base
  belongs_to :account
  has_many :likes
  validates :content, :length => {:within => 1..180}
end
