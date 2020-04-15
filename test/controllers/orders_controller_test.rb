require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get payment" do
    get orders_payment_url
    assert_response :success
  end

  test "should get index" do
    get orders_index_url
    assert_response :success
  end

  test "should get show" do
    get orders_show_url
    assert_response :success
  end

  test "should get destroy" do
    get orders_destroy_url
    assert_response :success
  end

end
