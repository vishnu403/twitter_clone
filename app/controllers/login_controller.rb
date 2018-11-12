class LoginController < ApplicationController

  def login
    @user = find_user_by_email(params[:user][:email])
    @user = authenticated_user(@user, params[:user][:password])
    if(@user)
      token = JWT.encode({user:@user.email},Rails.application.secrets.secret_key_base)
      render :json => {"msg":"login Succesfull","token":"#{token}"}
    else
      render :json => "invalid email or password"
    end
  rescue => exception
    render :json => exception.message
  end

  def find_user_by_email(email)
    Account.find_by(email:email)
  end

  def authenticated_user(user,password)
    user != nil and user.authenticate(password)
  end
  private

  def allowed_params
    params.require(:user).permit(:email,:handle,:password)
  end
end
