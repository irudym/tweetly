class TweetlyTools
  CONSUMER_KEY = ENV["consumer_key"]
  CONSUMER_SECRET = ENV["consumer_secret"]
  ACCESS_TOKEN = ENV["access_token"]
  ACCESS_TOKEN_SECRET = ENV["access_token_secret"]


  def self.find_user(user_name)
    begin
    # get user IDs
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = CONSUMER_KEY
      config.consumer_secret     = CONSUMER_SECRET
      config.access_token        = ACCESS_TOKEN
      config.access_token_secret = ACCESS_TOKEN_SECRET
    end

    Rails.logger.info "Get user IDs:: #{user_name}"
    user_ids = client.users(user_name)
    user_ids.each do |user|
      Rails.logger.debug "User: #{user.id}"
    end
    {error: nil, users: user_ids}
    rescue Exception => e
      Rails.logger.fatal "Error!: #{e}"
      {error: e, users: nil}
    end
  end

  def self.reload_agent
    unless TweetlyJob.pending?
      Rails.logger.info "restart the agent"
      TweetlyJob.set_status true
      AgentReloadJob.perform_in(120, "reload")
    else
      Rails.logger.info "the agent is already going to be restarted!"
    end
  end

end