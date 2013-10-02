require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  include AuthHelper

  def setup
    http_login
  end

  test 'should destroy a post' do
    session[:auth] = orders(:one).id

    assert_difference('Order.count', -1) do
      delete :destroy, id: orders(:one).id
    end

    assert_redirected_to new_order_path
  end

  test 'should not destroy a post if the authentication token doesn\'t exist' do
    session[:auth] = nil

    assert_difference('Order.count', 0) do
      delete :destroy, id: orders(:one).id
    end

    assert_redirected_to new_order_path
  end

  test 'should display all orders' do
    get :display_all

    assert_equal assigns(:orders).size, 2
  end

  test 'should clear all orders when admin clicks delete all' do
    delete :destroy_all

    assert_equal Order.count, 0

    items = Item.all

    items.each do |item|
      assert_equal false, item.available
    end

    assert_redirected_to items_path

    assert_not_nil flash[:notice]
  end

  test 'should list (only available) orders sorted by price' do
    get :new

    assert_equal [items(:three),items(:one)], assigns(:items).to_a
  end

  test 'should flash error if order is not saved and not redirect to that order' do
    post :create, order: {name: nil}, items: [items(:one).id]

    assert_not_nil flash[:error]
    assert_redirected_to new_order_path
  end
end
