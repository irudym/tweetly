class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @subscriptions = current_user.subscriptions
    # @agent_status = "running" # TweetlyTools.get_status('tweetly')
  end

  def new
    @users = {error: nil, users: []}
    @subscription = Subscription.new
  end

  def search
    user_name = params[:name]
    @users = TweetlyTools.find_user(user_name)
    if user_name == ""
      @users[:error] = "The user name cannot be blank!"
    end
    if @users[:error]
      render 'new'
    else
      @subscription = Subscription.new
      userlist = @users[:users].collect do |user|
        {id: user.id, name: user.name, subscribed: !current_user.subscriptions.where(twitter_id: user.id).empty?}
      end
      @users[:users] = userlist
      render 'list'
    end
  end

  def list
    @subscription = Subscription.new
  end

  def subscribe
  end

  def create
    # subscribe to id, name
    @subscription = Subscription.new(twitter_id: params[:id], twitter_name: params[:name], user_id: current_user.id)
    respond_to do |format|
      if @subscription.save
        TwitlyMailer.subscription_mail(current_user, params[:name]).deliver_later
        TweetlyTools.reload_agent
        format.html { redirect_to new_subscription_path, notice: "You were subscribed to #{params[:name]}." }
        format.json { render :show, status: :created, location: @subscription }
      else
        puts "ERROR!: #{@subscription.errors.to_a}"
        format.html { redirect_to new_subscription_path}
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @subscription = Subscription.where(id: params[:id]).first
    @subscription.destroy
    TweetlyTools.reload_agent
    respond_to do |format|
      format.html { redirect_to subscriptions_path, notice: 'You were un-subscribed.' }
      format.json { head :no_content }
    end
  end

  def logout
  end

end
