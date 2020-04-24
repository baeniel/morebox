require 'test_helper'

class ApisControllerTest < ActionDispatch::IntegrationTest
  test "should get pay_url" do
    get apis_pay_url_url
    assert_response :success
  end

end
