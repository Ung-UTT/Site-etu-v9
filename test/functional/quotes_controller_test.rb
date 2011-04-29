require 'test_helper'

class QuotesControllerTest < ActionController::TestCase
  setup do
    @quote = quotes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quotes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quote" do
    assert_difference('Quote.count') do
      post :create, :quote => @quote.attributes
    end

    assert_redirected_to quote_path(assigns(:quote))
  end

  test "should show quote" do
    get :show, :id => @quote.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @quote.to_param
    assert_response :success
  end

  test "should update quote" do
    put :update, :id => @quote.to_param, :quote => @quote.attributes
    assert_redirected_to quote_path(assigns(:quote))
  end

  test "should destroy quote" do
    assert_difference('Quote.count', -1) do
      delete :destroy, :id => @quote.to_param
    end

    assert_redirected_to quotes_path
  end
end
