require 'test_helper'

class DestinationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Destination.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Destination.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Destination.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to destination_url(assigns(:destination))
  end
  
  def test_edit
    get :edit, :id => Destination.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Destination.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Destination.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Destination.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Destination.first
    assert_redirected_to destination_url(assigns(:destination))
  end
  
  def test_destroy
    destination = Destination.first
    delete :destroy, :id => destination
    assert_redirected_to destinations_url
    assert !Destination.exists?(destination.id)
  end
end
