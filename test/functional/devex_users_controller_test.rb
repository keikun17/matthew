require 'test_helper'

class DevexUsersControllerTest < ActionController::TestCase
  setup do
    @devex_user = devex_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:devex_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create devex_user" do
    assert_difference('DevexUser.count') do
      post :create, :devex_user => @devex_user.attributes
    end

    assert_redirected_to devex_user_path(assigns(:devex_user))
  end

  test "should show devex_user" do
    get :show, :id => @devex_user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @devex_user.to_param
    assert_response :success
  end

  test "should update devex_user" do
    put :update, :id => @devex_user.to_param, :devex_user => @devex_user.attributes
    assert_redirected_to devex_user_path(assigns(:devex_user))
  end

  test "should destroy devex_user" do
    assert_difference('DevexUser.count', -1) do
      delete :destroy, :id => @devex_user.to_param
    end

    assert_redirected_to devex_users_path
  end
end
