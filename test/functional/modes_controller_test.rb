require 'test_helper'

class ModesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Mode.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Mode.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Mode.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to mode_url(assigns(:mode))
  end
  
  def test_edit
    get :edit, :id => Mode.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Mode.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Mode.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Mode.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Mode.first
    assert_redirected_to mode_url(assigns(:mode))
  end
  
  def test_destroy
    mode = Mode.first
    delete :destroy, :id => mode
    assert_redirected_to modes_url
    assert !Mode.exists?(mode.id)
  end
end
