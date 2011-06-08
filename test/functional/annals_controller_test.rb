require 'test_helper'

class AnnalsControllerTest < ActionController::TestCase
  setup do
    @annal = annals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:annals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create annal" do
    assert_difference('Annal.count') do
      post :create, :annal => @annal.attributes
    end

    assert_redirected_to annal_path(assigns(:annal))
  end

  test "should show annal" do
    get :show, :id => @annal.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @annal.to_param
    assert_response :success
  end

  test "should update annal" do
    put :update, :id => @annal.to_param, :annal => @annal.attributes
    assert_redirected_to annal_path(assigns(:annal))
  end

  test "should destroy annal" do
    assert_difference('Annal.count', -1) do
      delete :destroy, :id => @annal.to_param
    end

    assert_redirected_to annals_path
  end
end
