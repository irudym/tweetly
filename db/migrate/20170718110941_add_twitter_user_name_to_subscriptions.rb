class AddTwitterUserNameToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :twitter_name, :string
    add_column :subscriptions, :twitter_id, :integer
    remove_column :subscriptions, :twitter_user
  end
end
