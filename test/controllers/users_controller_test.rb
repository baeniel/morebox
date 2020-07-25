require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get pay_complete" do
    get users_pay_complete_url
    assert_response :success
  end

end
