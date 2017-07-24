class CreateTweetlyJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :tweetly_jobs do |t|
      t.boolean :pending

      t.timestamps
    end
  end
end
