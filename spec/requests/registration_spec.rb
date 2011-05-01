require 'spec_helper'

describe "Sign in via Facebook for New User" do
  before :all do
    FakeWeb.allow_net_connect = true
    OmniAuth.config.test_mode = false
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean!
  end

  context "from home page" do
    before do
      visit '/'
    end

    it 'goes to Facebook' do
      click_link 'Sign in with Facebook'
      page.current_url.should =~ %r{graph.facebook.com/oauth/authorize}
    end

    context "on Facebook page" do
      before do
        click_link 'Sign in with Facebook'
      end

      it 'accepts Facebook credentials and redirects to sign-up page' do
        fill_in 'Username or Email:', :with => FACEBOOK_USERNAME
        fill_in 'session[password]', :with => FACEBOOK_PASSWORD
        click_button 'Sign in'
        page.current_path.should == '/users/sign_up'
      end

      context "on Sign-up page" do
        before do
         fill_in 'Username or Email:', :with => FACEBOOK_USERNAME
          fill_in 'session[password]', :with => FACEBOOK_PASSWORD
          click_button 'Sign in'
        end

        it 'accepts email, first, last name and proceeds to home page' do
          fill_in 'Email', :with => Factory.attributes_for(:user)[:email]
          fill_in 'First name', :with => 'Sally'
          fill_in 'Last name', :with => 'Parker'
          click_button 'Create account'
          page.current_path.should == '/'
          page.should have_content('Welcome! You have signed up successfully.')
          page.should have_link('Sign out')
        end
      end
    end
  end
end
