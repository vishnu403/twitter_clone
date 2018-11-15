require 'rails_helper'

RSpec.describe "LikeController", type: :request do
  describe "liking a tweet" do
    it "give a positive response as liked" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      tweet = Tweet.create(content:"tweet content testing",account_id:5)
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/tweet/#{tweet.id}/like",{:like => {:account_id =>5,:tweet_id =>tweet.id}},headers
      expect(JSON.parse(response.body)["status"]).to eql("liked")
    end

    it "give a 422 status code if the tweet does not exist" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/tweet/23/like",{:like => {:account_id =>5,:tweet_id =>23}},headers
      expect(response.status).to eql(422)
    end
  end
end
