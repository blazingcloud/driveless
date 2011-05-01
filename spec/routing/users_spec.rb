require 'spec_helper'

# Note: We're using the ActionDispatch::IntegrationTest API here
# This is Rails's own native Integration framework (with a thin RSPec wrapper around it).
# It is not Capybara or Webrat!
# see: http://railsapi.com/doc/rails-v3.0.4/classes/ActionDispatch/IntegrationTest.html

describe "Users" do
  describe "Sign In with Facebook" do
    describe "New user" do
      before do
        login_with_via(:facebook)
      end
      it 'is redirected to registration page' do
        response.should redirect_to(new_user_registration_path)
      end
      it 'proceeds from registration page to root path' do
        post user_registration_path, :user => {:email => Factory.attributes_for(:facebook_user)[:email],
                                               :first_name => 'Joe',
                                               :last_name  => 'Smith'}
        response.should redirect_to(root_path)
        follow_redirect!
        response.should have_selector("a[href='#{destroy_user_session_path}']")
      end
      it 'stays on registration page when there are errors' do
        post user_registration_path, :user => {:email => Factory.attributes_for(:facebook_user)[:email],
                                               :last_name  => 'Smith'}
        response.should be_success
        response.body.should include("First name can't be blank")
      end
    end
  end
end
