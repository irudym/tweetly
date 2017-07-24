require 'test_helper'

class SubscribeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get subscribe_index_url
    assert_response :success
  end

end
