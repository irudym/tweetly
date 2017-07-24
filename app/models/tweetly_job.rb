class TweetlyJob < ApplicationRecord
  def self.set_status(status)
    if TweetlyJob.all.empty?
      TweetlyJob.create!(pending: status)
    else
      TweetlyJob.all.first.update!(pending: status)
    end
  end

  def self.pending?
    TweetlyJob.all.first.pending == true
  end
end
