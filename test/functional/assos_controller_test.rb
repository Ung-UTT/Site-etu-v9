require 'test_helper'

class AssosControllerTest < ActionController::TestCase
  setup do
    @asso = asso(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:asso)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create asso" do
    assert_difference('Asso.count') do
      post :create, :asso => @asso.attributes
    end

    assert_redirected_to asso_path(assigns(:asso))
  end

  test "should show asso" do
    get :show, :id => @asso.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @asso.to_param
    assert_response :success
  end

  test "should update asso" do
    put :update, :id => @asso.to_param, :asso => @asso.attributes
    assert_redirected_to asso_path(assigns(:asso))
  end

  test "should destroy asso" do
    assert_difference('Asso.count', -1) do
      delete :destroy, :id => @asso.to_param
    end

    assert_redirected_to asso_path
  end
end
