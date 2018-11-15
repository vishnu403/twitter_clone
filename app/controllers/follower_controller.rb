class FollowerController < ApplicationController

  before_action :authenticate_user

  def authenticate_user
    @user = Account.find_by(email:JWT.decode(request.headers["token"],Rails.application.secrets.secret_key_base).first["user"])
    if @user.nil? or @user.id.to_s != params[:account_id].to_s
      render :json => {:user => :invaliduser}, :status => 401
    end
  rescue => e
    render :json => {:user => :invaliduser , :errors => e.message }, :status => 401
  end

  def create
    following = @user.followers.new(allowed_params)
    if(following.save)
      render :json => {:following => Account.find(following.following_account_id).handle , :status => :followed}
    else
      render :json => {:following => following.errors} , :status => 422
    end
  end

  def destroy
    following = @user.followers.find_by(following_account_id:params[:id])
    if(following.destroy)
      render :json => {:unfollowed => following, :status => :unfollowed }
    else
      render :json => {:errors => following.errors}, :status => 422
    end
  rescue => e
    render :json => {:errors => e.message}, :status => 422
  end

  private

  def allowed_params
    params.require(:follower).permit(:following_account_id)
  end
end
