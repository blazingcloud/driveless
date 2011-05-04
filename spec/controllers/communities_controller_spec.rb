require 'spec_helper'

describe CommunitiesController do
  include Devise::TestHelpers
  
  context "as non-admin user" do
    before do
      @user = User.make
      sign_in @user
    end
    it "should not be able to create" do
      post :create, :community => {:name => "fake"}
      page.should redirect_to(root_path)
    end
    it "should not be able to destroy" do
      c = Community.make
      delete :destroy, :id => c.id
      c.reload
      c.should_not be_nil
      page.should redirect_to(root_path)
    end
    it "should not be able to update" do
      c = Community.make
      put :update, :id => c.id, :community => { :name => "fake"}
      c.reload
      c.name.should_not == "fake"      
      page.should redirect_to(root_path)
    end
  end
end