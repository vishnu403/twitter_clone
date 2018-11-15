require 'rails_helper'

RSpec.describe "FollowerController", type: :request do
  describe "following a user" do
    it "should return the status as followed" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      user2 = Account.create(email:"vishnupillai@gmail.com", password:"helloworld",handle:"@vish")

      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/follower",{:follower => {:following_account_id => user2.id}},headers
      expect(JSON.parse(response.body)["status"]).to eql("followed")
    end

    it "should return the status code 422 as it is already been followed by the user" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      user2 = Account.create(email:"vishnupillai@gmail.com", password:"helloworld",handle:"@vish")

      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/follower",{:follower => {:following_account_id => user2.id}},headers
      post "/account/#{user1.id}/follower",{:follower => {:following_account_id => user2.id}},headers
      expect(response.status).to eql(422)
    end
  end

  describe "unfollowing a user" do
    it "should return the status as unfollowed" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      user2 = Account.create(email:"vishnupillai@gmail.com", password:"helloworld",handle:"@vish")

      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      post "/account/#{user1.id}/follower",{:follower => {:following_account_id => user2.id}},headers
      delete "/account/#{user1.id}/follower/#{user2.id}",{},headers
      expect(JSON.parse(response.body)["status"]).to eql("unfollowed")
    end
    it "should return the status code 422 as the user is trying to unfollow someone who he doesnt follow" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      user2 = Account.create(email:"vishnupillai@gmail.com", password:"helloworld",handle:"@vish")

      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",
          "token" => "#{token}"
      }
      delete "/account/#{user1.id}/follower/#{user2.id}",{},headers
      expect(response.status).to eql(422)
    end
  end
end
