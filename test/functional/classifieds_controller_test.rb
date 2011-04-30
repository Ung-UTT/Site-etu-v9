require 'test_helper'

class ClassifiedsControllerTest < ActionController::TestCase
  setup do
    @classified = classifieds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:classifieds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create classified" do
    assert_difference('Classified.count') do
      post :create, :classified => @classified.attributes
    end

    assert_redirected_to classified_path(assigns(:classified))
  end

  test "should show classified" do
    get :show, :id => @classified.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @classified.to_param
    assert_response :success
  end

  test "should update classified" do
    put :update, :id => @classified.to_param, :classified => @classified.attributes
    assert_redirected_to classified_path(assigns(:classified))
  end

  test "should destroy classified" do
    assert_difference('Classified.count', -1) do
      delete :destroy, :id => @classified.to_param
    end

    assert_redirected_to classifieds_path
  end
end
