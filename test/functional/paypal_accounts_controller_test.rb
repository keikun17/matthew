require 'test_helper'

class PaypalAccountsControllerTest < ActionController::TestCase
  setup do
    @paypal_account = paypal_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paypal_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paypal_account" do
    assert_difference('PaypalAccount.count') do
      post :create, :paypal_account => @paypal_account.attributes
    end

    assert_redirected_to paypal_account_path(assigns(:paypal_account))
  end

  test "should show paypal_account" do
    get :show, :id => @paypal_account.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @paypal_account.to_param
    assert_response :success
  end

  test "should update paypal_account" do
    put :update, :id => @paypal_account.to_param, :paypal_account => @paypal_account.attributes
    assert_redirected_to paypal_account_path(assigns(:paypal_account))
  end

  test "should destroy paypal_account" do
    assert_difference('PaypalAccount.count', -1) do
      delete :destroy, :id => @paypal_account.to_param
    end

    assert_redirected_to paypal_accounts_path
  end
end
