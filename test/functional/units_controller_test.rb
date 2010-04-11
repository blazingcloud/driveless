require 'test_helper'

class UnitsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Unit.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Unit.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Unit.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to unit_url(assigns(:unit))
  end
  
  def test_edit
    get :edit, :id => Unit.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Unit.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Unit.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Unit.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Unit.first
    assert_redirected_to unit_url(assigns(:unit))
  end
  
  def test_destroy
    unit = Unit.first
    delete :destroy, :id => unit
    assert_redirected_to units_url
    assert !Unit.exists?(unit.id)
  end
end
