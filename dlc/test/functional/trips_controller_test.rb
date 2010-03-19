require 'test_helper'

class TripsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Trip.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Trip.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Trip.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to trip_url(assigns(:trip))
  end
  
  def test_edit
    get :edit, :id => Trip.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Trip.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Trip.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Trip.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Trip.first
    assert_redirected_to trip_url(assigns(:trip))
  end
  
  def test_destroy
    trip = Trip.first
    delete :destroy, :id => trip
    assert_redirected_to trips_url
    assert !Trip.exists?(trip.id)
  end
end
