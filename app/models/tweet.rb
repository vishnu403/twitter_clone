class Tweet < ActiveRecord::Base
  belongs_to :account
  validates :content, :length => {:within => 1..180}
end
