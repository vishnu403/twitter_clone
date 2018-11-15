class TweetController < ApplicationController

  before_action :authenticate_user

  def authenticate_user
    @user = Account.find_by(email:JWT.decode(request.headers["token"],Rails.application.secrets.secret_key_base).first["user"])
    if @user.nil? or @user.id.to_s != params[:account_id].to_s
      render :json => {:user => :invaliduser}, :status => 401
    end
  rescue => e
    render :json => {:user => :invaliduser , :errors => e.message }, :status => 401
  end

  def index
      tweets = (@user.tweets.paginate(:page => params[:page], :per_page => 5))
      if(tweets)
        render :json => {:tweets => tweets, :status => :tweets_fetched}
      else
        render :json => {:tweets => tweets.errors, :status => :unable_to_get_tweets}
      end
  end

  def create
      tweet = @user.tweets.new(allowed_params)
      if(tweet.save)
        render :json => {:tweet => tweet , :status => :created}
      else
        render :json => {:tweet => tweet.errors} , :status => 422
      end
  end

  def update
      tweet = @user.tweets.find(params[:id])

      if(tweet.update(allowed_params))
        render :json => {:updated_tweet => tweet, :status => :updated }
      else
        render :json => {:error => tweet.errors}, :status => 422
      end
  rescue => e
    render :json => {:errors => e.message}, :status => 422
  end

  def retweet
    puts params
    tweet = Tweet.find(params[:id])
    params[:tweet] = {:content => tweet.content}
    re_tweet = create()
  rescue => e
    render :json => {:errors => e.message}, :status => 422
  end

  def destroy
      tweet = @user.tweets.find(params[:id])
      if(tweet.destroy)
        render :json => {:deleted_tweet => tweet, :status => :deleted }
      else
        render :json => {:errors => tweet.errors}, :status => 422
      end
  rescue => e
    render :json => {:errors => e.message}, :status => 422
  end

  private

  def allowed_params
    params.require(:tweet).permit(:content,:account_id)
  end
end
