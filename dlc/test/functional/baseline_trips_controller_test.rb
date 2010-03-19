require 'test_helper'

class BaselineTripsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => BaselineTrips.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    BaselineTrips.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    BaselineTrips.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to baseline_trips_url(assigns(:baseline_trips))
  end
  
  def test_edit
    get :edit, :id => BaselineTrips.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    BaselineTrips.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BaselineTrips.first
    assert_template 'edit'
  end
  
  def test_update_valid
    BaselineTrips.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BaselineTrips.first
    assert_redirected_to baseline_trips_url(assigns(:baseline_trips))
  end
  
  def test_destroy
    baseline_trips = BaselineTrips.first
    delete :destroy, :id => baseline_trips
    assert_redirected_to baseline_trips_url
    assert !BaselineTrips.exists?(baseline_trips.id)
  end
end
