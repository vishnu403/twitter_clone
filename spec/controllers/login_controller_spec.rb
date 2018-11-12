require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  describe "User login" do
    it "should return user with the provided email" do
      user = Account.create(email:"vishu@gmail.com", password:"zooooooom",handle:"@handle")
      expect(subject.find_user_by_email("vishu@gmail.com")).to eql(user)
    end
    it "should return  nil if user email didn't match any" do
      user = Account.create(email:"vu@gmail.com", password:"zooooooom",handle:"@handle")
      expect(subject.find_user_by_email("vishu@gmail.com")).to eql(nil)
    end
    it "should authenticate user with username and password" do
      user1 = Account.create(email:"vu@gmail.com", password:"zooooooom",handle:"@handle")
      expect(subject.authenticated_user(user1,"zooooooom")).to eql(user1)
    end
    it "should return false as user is nil" do
      user1 = Account.create(email:"vu@gmail.com", password:"zooooooom",handle:"@handle")
      expect(subject.authenticated_user(nil,"zooooooom")).to eql(false)
    end
    it "should return false as password is incorrect" do
      user1 = Account.create(email:"vu@gmail.com", password:"zooooooom",handle:"@handle")
      expect(subject.authenticated_user(user1,"zooooom")).to eql(false)
    end
    it "login in with right username and password" do
      user1 = Account.create(email:"vu@gmail.com", password:"zooooooom",handle:"@handle")
      post :login, :user => {email:"vu@gmail.com", password:"zooooooom"}
      expect(JSON.parse(response.body)["msg"]).to eql('login Succesfull')
    end
    it "login in with wrong email" do
      user1 = Account.create(email:"vu@gmail.com", password:"zooooooom",handle:"@handle")
      post :login, :user => {email:"vu@gmil.com", password:"zooooooom"}
      expect((response.body)).to eql('invalid email or password')
    end
    it "login in with wrong password" do
      user1 = Account.create(email:"vu@gmail.com", password:"zooooooom",handle:"@handle")
      post :login, :user => {email:"vu@gmail.com", password:"zooom"}
      expect((response.body)).to eql('invalid email or password')
    end
  end
end
