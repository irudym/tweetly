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

    puts "Get user IDs:: #{user_name}"
    user_ids = client.users(user_name)
    user_ids.each do |user|
      puts "User: #{user.id}"
    end
    {error: nil, users: user_ids}
    rescue Exception => e
      puts "Error!: #{e}"
      {error: e, users: nil}
    end
  end

  def self.reload_agent
    unless TweetlyJob.pending?
      TweetlyJob.set_status true
      AgentReloadJob.perform_in(120, "reload")
    else
      puts "the agent is already going to be restarted!"
    end
  end

end