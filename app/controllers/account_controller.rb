class AccountController < ApplicationController
  def create
    if(password_validate?(params[:user][:password]))
      @user = Account.new(allowed_params)
      render :json => (@user.save ? @user:@user.errors)
    else
      render :json => {"password" => ["is too short (minimum is 6 characters)"]},:status => 422
    end
  end

  def password_validate?(password)
    password.length > 6 and password.length < 60
  end

  def update
    logged_in_user = check_login_state()
    @user = Account.find(params[:id])
    if(@user === logged_in_user)
      render :json => @user.update(allowed_params_details) ? @user:@user.errors
    else
      render :json => "invalid update operation",:status => 422
    end
  rescue => e
    render :json => e.message
  end

  private

  def check_login_state()
    Account.find_by(email:JWT.decode(request.headers["token"],Rails.application.secrets.secret_key_base).first["user"])
  end

  def allowed_params
    params.require(:user).permit(:email,:handle,:password)
  end

  def allowed_params_details
    params.require(:details).permit(:name,:bio,:image)
  end
end
