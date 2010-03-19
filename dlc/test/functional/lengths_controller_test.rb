require 'test_helper'

class LengthsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Length.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Length.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Length.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to length_url(assigns(:length))
  end
  
  def test_edit
    get :edit, :id => Length.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Length.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Length.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Length.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Length.first
    assert_redirected_to length_url(assigns(:length))
  end
  
  def test_destroy
    length = Length.first
    delete :destroy, :id => length
    assert_redirected_to lengths_url
    assert !Length.exists?(length.id)
  end
end
