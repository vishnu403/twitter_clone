class LikeController < ApplicationController

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
    like = Tweet.find(params[:tweet_id]).likes.new(allowed_params)
    if(like.save)
      render :json => {:status => :liked}
    else
      render :json => {:errors => like.errors} , :status => 422
    end
  rescue => e
    render :json => {:errors => e.message}, :status => 422
  end

  private
  def allowed_params
    params.require(:like).permit(:account_id,:tweet_id)
  end
end
