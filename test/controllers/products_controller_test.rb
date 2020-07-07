require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get marketing" do
    get products_marketing_url
    assert_response :success
  end

end
