require 'rails_helper'

RSpec.describe "TweetController", type: :request do
  describe "tweeting done by a user" do
    it "should return the count of tweet by the user1 i.e 2" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      user2 = Account.create(email:"vishnu403@gmail.com", password:"helloworld",handle:"@visnu")
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 1"}},headers
      post "/account/#{user1.id}/tweet",{:tweet =>{"content":"tweet 2"}},headers
      expect(user1.get_tweet_count).to eql(2)
    end
    it "should return the count of tweet by the user2 i.e 0" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      user2 = Account.create(email:"vishnu403@gmail.com", password:"helloworld",handle:"@visnu")
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 1"}},headers
      post "/account/#{user1.id}/tweet",{:tweet =>{"content":"tweet 2"}},headers
      expect(user2.get_tweet_count).to eql(0)
    end
  end
  describe "deleting a tweet" do
    it "should delete the tweet and the tweet count fo the user should be reduced" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 1"}},headers
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 2"}},headers
      res = JSON.parse(response.body)
      delete "/account/#{user1.id}/tweet/#{res["tweet"]["id"]}",{},headers
      expect(user1.get_tweet_count).to eql(1)
    end

    it "should say user not found as the account id is invalid" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 1"}},headers
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 2"}},headers
      res = JSON.parse(response.body)
      delete "/account/34/tweet/#{res["tweet"]["id"]}",{},headers
      expect(JSON.parse(response.body)["user"]).to eql("invaliduser")
    end

    it "should say tweet not found as the tweet id is invalid" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 1"}},headers
      post "/account/#{user1.id}/tweet",{:tweet =>{"content":"tweet 2"}},headers
      res = JSON.parse(response.body)
      delete "/account/#{user1.id}/tweet/9999",{},headers
      expect(response.status).to eql(422)
    end
  end
  describe "updating or editing a tweet" do
    it "should update the contents of the tweet" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 1"}},headers
      post "/account/#{user1.id}/tweet",{:tweet =>{"content":"tweet 2"}},headers
      res = JSON.parse(response.body)
      put "/account/#{user1.id}/tweet/#{res["tweet"]["id"]}",{:tweet => {"content":"tweet 1 edited content"}},headers
      expect(JSON.parse(response.body)["updated_tweet"]["content"]).to eql("tweet 1 edited content")
    end
  end
  describe "paginating all tweets" do
    it "should return the first 5 tweets from page 1" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 1"}},headers
      post "/account/#{user1.id}/tweet",{:tweet =>{"content":"tweet 2"}},headers
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 3"}},headers
      post "/account/#{user1.id}/tweet",{:tweet =>{"content":"tweet 4"}},headers
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 5"}},headers
      post "/account/#{user1.id}/tweet",{:tweet =>{"content":"tweet 6"}},headers
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 7"}},headers
      post "/account/#{user1.id}/tweet",{:tweet =>{"content":"tweet 8"}},headers

      get "/account/#{user1.id}/tweet",{:page => 1},headers
      expect(JSON.parse(response.body)["tweets"].length).to eql(5)
    end
    it "should return the last 3 tweets from page 2" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 1"}},headers
      post "/account/#{user1.id}/tweet",{:tweet =>{"content":"tweet 2"}},headers
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 3"}},headers
      post "/account/#{user1.id}/tweet",{:tweet =>{"content":"tweet 4"}},headers
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 5"}},headers
      post "/account/#{user1.id}/tweet",{:tweet =>{"content":"tweet 6"}},headers
      post "/account/#{user1.id}/tweet",{:tweet => {"content":"tweet 7"}},headers
      post "/account/#{user1.id}/tweet",{:tweet =>{"content":"tweet 8"}},headers

      get "/account/#{user1.id}/tweet",{:page => 2},headers
      expect(JSON.parse(response.body)["tweets"].length).to eql(3)
    end
  end

  describe "retweeting a tweet" do
    it "give a positive response as created" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      tweet = Tweet.create(content:"tweet content testing",account_id:5)
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      put "/account/#{user1.id}/tweet/#{tweet.id}/retweet",{},headers
      expect(JSON.parse(response.body)["status"]).to eql("created")
    end

    it "give a 422 status code if the tweet does not exist" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      # tweet = Tweet.create(content:"tweet content testing",account_id:5)
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      put "/account/#{user1.id}/tweet/23/retweet",{},headers
      expect(response.status).to eql(422)
    end
  end
end
