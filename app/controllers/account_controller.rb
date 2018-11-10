class AccountController < ApplicationController

  def create
    @user = Account.new(allowed_params)
    render :json => ( @user.save ? @user:@user.errors)
  end

  private

  def allowed_params
    params.require(:user).permit(:email,:handle,:password)
  end
end
