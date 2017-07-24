class TwitlyMailer < ApplicationMailer
  default from: 'subsription@twitly.com'

  def subscription_mail(user, twitter_user)
    @user = user
    @twitter_user = twitter_user
    mail(to: @user.email, subject: "Your were subscribed to twitter account: #{twitter_user}")
  end

  def post_mail(user, twitter_user, text)
    @user = user
    @twitter_user = twitter_user
    @tweet_text = text
    mail(to: @user.email, subject: "New tweet from : #{twitter_user}")
  end
end
