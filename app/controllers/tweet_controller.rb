class TweetController < ApplicationController

  def index
    logged_in_user = check_login_state()
    @user = Account.find(params[:account_id])
    if(@user === logged_in_user)
      @tweets = (Tweet.paginate(:page => params[:page], :per_page => 5))
      render :json => @tweets ? @tweets:@tweets.errors
    else
      render :json => "invalid operation"
    end
  end

  def create
    logged_in_user = check_login_state()
    @user = Account.find(params[:account_id])
    if(@user === logged_in_user)
      params[:tweet][:account_id] = @user.id
      @tweet = Tweet.new(allowed_params)
      render :json => (@tweet.save ? @tweet:@tweet.errors)
    else
      render :json => "invalid operation"
    end
  rescue => e
    render :json => e.message
  end

  def update
    logged_in_user = check_login_state()
    @user = Account.find(params[:account_id])
    if(@user === logged_in_user)
      @tweet = Tweet.find(params[:id])
      render :json => (@tweet.update(allowed_params) ? @tweet:@tweet.errors)
    else
      render :json => 'invalid operation'
    end
  end

  def destroy
    logged_in_user = check_login_state()
    @user = Account.find(params[:account_id])
    if( @user === logged_in_user)
      @tweet = Tweet.find(params[:id])
      render :json => (@tweet.destroy() ? @tweet:@tweet.errors)
    else
      render :json => "invalid operation"
    end

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
