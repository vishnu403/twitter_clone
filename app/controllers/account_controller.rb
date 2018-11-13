class AccountController < ApplicationController

  def create
    if(password_validate?(params[:user][:password]))
      @user = Account.new(allowed_params)
      render :json => (@user.save ? @user:@user.errors)
    else
      render :json => {"password" => ["is too short (minimum is 6 characters)"]}
    end
  end

  def password_validate?(password)
    password.length > 6 and password.length < 60
  end

  def add_details
    # request.headers.each {|key,value| puts "#{key} : #{value}"}
    @user = Account.find_by(email:JWT.decode(request.headers["token"],Rails.application.secrets.secret_key_base).first["user"])
    render :json => @user.update(allowed_params_details) ? @user:@user.errors
  rescue => e
    render :json => e.message
  end

  private

  def allowed_params
    params.require(:user).permit(:email,:handle,:password)
  end

  def allowed_params_details
    params.require(:details).permit(:name,:bio,:image)
  end
end
