require 'rails_helper'

RSpec.describe AccountController, type: :controller do
  describe "Create a new Account" do
    it "should return newly created user" do
      post :create, :user => { "email": 'newmail@ya.ru',"handle":"@newuser","password":"password"}
      expect(JSON.parse(response.body)["email"]).to eql('newmail@ya.ru')
    end
    it "should return invalid email" do
      post :create, :user => { "email": 'newmailya.ru',"handle":"@newuser","password":"password"}
      expect(JSON.parse(response.body)).to eql("email"=>['is invalid'])
    end
    it "should return handle already taken" do
      post :create, :user => { "email": 'new@ya.ru',"handle":"@newuser","password":"password"}
      post :create, :user => { "email": 'newmail@ya.ru',"handle":"@newuser","password":"password"}
      expect(JSON.parse(response.body)).to eql("handle"=>['has already been taken'])
    end
    it "should return email already taken" do
      post :create, :user => { "email": 'newmail@ya.ru',"handle":"@newuser2","password":"password"}
      post :create, :user => { "email": 'newmail@ya.ru',"handle":"@newuser","password":"password"}
      expect(JSON.parse(response.body)).to eql("email"=>['has already been taken'])
    end
    it "should return email and handle both already taken" do
      post :create, :user => { "email": 'newmail@ya.ru',"handle":"@newuser","password":"password"}
      post :create, :user => { "email": 'newmail@ya.ru',"handle":"@newuser","password":"password"}
      expect(JSON.parse(response.body)).to eql("email"=>['has already been taken'],"handle"=>['has already been taken'])
    end
    it "should return password too short" do
      post :create, :user => { "email": 'newmail@ya.ru',"handle":"@newuser2","password":"h"}
      expect(JSON.parse(response.body)).to eql("password" => ["is too short (minimum is 6 characters)"])
    end
    it "validate password lenght" do
      expect(subject.password_validate?("hello")).to eql(false)
    end
    it "validate password length" do
      expect(subject.password_validate?("heloooooooo")).to eql(true)
    end
  end


end
RSpec.describe "AccountController", type: :request do
  describe "adding details to the Account" do
    it "should return user with added name and bio" do
      user1 = Account.create(email:"vishnupillai403@gmail.com", password:"helloworld",handle:"@vishnu")
      post "/login", {:user => {"email":"vishnupillai403@gmail.com","password":"helloworld"}}
      token = JSON.parse(response.body)["token"]
      headers = {
          "ACCEPT" => "application/json",     # This is what Rails 4 accepts
          "token" => "#{token}"
      }
      put "/addDetails",{:details => {"name":"Vishnu Pillai","bio":"backend developer"}},headers
      user1.update_attributes(name:"Vishnu Pillai","bio":"backend developer")
      expect(JSON.parse(response.body)["name"]).to eql("Vishnu Pillai")
    end
  end
end