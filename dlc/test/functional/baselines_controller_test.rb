require 'test_helper'

class BaselinesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Baseline.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Baseline.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Baseline.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to baseline_url(assigns(:baseline))
  end
  
  def test_edit
    get :edit, :id => Baseline.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Baseline.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Baseline.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Baseline.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Baseline.first
    assert_redirected_to baseline_url(assigns(:baseline))
  end
  
  def test_destroy
    baseline = Baseline.first
    delete :destroy, :id => baseline
    assert_redirected_to baselines_url
    assert !Baseline.exists?(baseline.id)
  end
end
