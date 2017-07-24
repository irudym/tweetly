class ChangeTwitterIdToTextInSubscriptions < ActiveRecord::Migration[5.0]
  def change
    remove_column :subscriptions, :twitter_id
    add_column :subscriptions, :twitter_id, :string
  end
end
