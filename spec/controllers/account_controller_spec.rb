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
    it "should return email already taken" do
      post :create, :user => { "email": 'newmail@ya.ru',"handle":"@newuser2","password":"pass"}
      expect(JSON.parse(response.body)).to eql("password" => ["is too short (minimum is 6 characters)"])
    end

  end
end