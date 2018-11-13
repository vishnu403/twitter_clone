class TweetController < ApplicationController

  before_action :get_user

  def get_user
    logged_in_user = check_login_state()
    user = Account.find(params[:account_id])
    @user = (logged_in_user === user) ? user:nil
  end

  def index
      @tweets = (@user.tweets.paginate(:page => params[:page], :per_page => 5))
      render :json => @tweets ? @tweets:@tweets.errors
  end

  def create
      params[:tweet][:account_id] = @user.id
      @tweet = @user.tweets.new(allowed_params)
      render :json => (@tweet.save ? @tweet:@tweet.errors)
  rescue => e
    render :json => e.message
  end

  def update
      @tweet = @user.tweets.find(params[:id])
      render :json => (@tweet.update(allowed_params) ? @tweet:@tweet.errors)
  end

  def destroy
      @tweet = @user.tweets.find(params[:id])
      render :json => (@tweet.destroy() ? @tweet:@tweet.errors)
  rescue => e
    render :json => e.message
  end

  def check_login_state()
    Account.find_by(email:JWT.decode(request.headers["token"],Rails.application.secrets.secret_key_base).first["user"])
  end

  private

  def allowed_params
    params.require(:tweet).permit(:content,:account_id)
  end
end
