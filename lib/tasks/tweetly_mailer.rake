require 'twitter'

APP_DIR = "#{Dir.home}/apps/tweetly"

class TweetlyMailer
  CONSUMER_KEY = ENV["consumer_key"]
  CONSUMER_SECRET = ENV["consumer_secret"]
  ACCESS_TOKEN = ENV["access_token"]
  ACCESS_TOKEN_SECRET = ENV["access_token_secret"]

  def initialize(logfile)
    TweetlyMailer.log "Tweetly mailer agent v0.2"
    @logfile = "#{APP_DIR}/log/#{logfile}"
    puts "LOG_file: #{@logfile}"
    @twitter_users_ids = Subscription.distinct.pluck(:twitter_id)
  end

  def redirect_output
    FileUtils.mkdir_p(File.dirname(@logfile), :mode => 0755)
    FileUtils.touch @logfile
    File.chmod(0644, @logfile)
    $stderr.reopen(@logfile, 'a')
    $stdout.reopen($stderr)
    $stdout.sync = $stderr.sync = true
  end

  def follow
    client = Twitter::Streaming::Client.new do | config|
      config.consumer_key = CONSUMER_KEY
      config.consumer_secret = CONSUMER_SECRET
      config.access_token = ACCESS_TOKEN
      config.access_token_secret = ACCESS_TOKEN_SECRET
    end
    TweetlyMailer.log "Follow: #{@twitter_users_ids.join(', ')}"
    client.filter(follow: @twitter_users_ids.join(', ')) do |object|
      if object.is_a?(Twitter::Tweet)
        if @twitter_users_ids.include? object.attrs[:user][:id_str]
          TweetlyMailer.log "User id: #{object.attrs[:user][:id_str]}"
          TweetlyMailer.log "User name: #{object.attrs[:user][:screen_name]}"
          TweetlyMailer.log "Text: #{object.text}"

          Subscription.where(twitter_id: object.attrs[:user][:id_str]).each do |item|
            TweetlyMailer.log "===> Send email to #{item.user.email}"
            TwitlyMailer.post_mail(item.user, object.attrs[:user][:screen_name], object.text).deliver_later
          end
        end
      end
    end
  end

  def self.log(text)
    puts "[#{DateTime.now.strftime("%d/%m/%Y %H:%M:%S")}]:: #{text}"
  end

end

namespace :tweetly do
  desc "Send mails with tweets of followed users"
  task start: :environment do
    puts "Start the agent"
    Process.daemon
    File.open("#{APP_DIR}/pid/tweetly.pid", "w") {|f| f.write("#{Process.pid}") }
    while true
      mailer = TweetlyMailer.new('tweetly.log')
      mailer.redirect_output
      begin
        mailer.follow
      rescue Exception => e
        TweetlyMailer.log "Error: #{e}!"
      end
      TweetlyMailer.log "Restart the agent!"
    end
  end
end