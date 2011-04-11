require 'spec_helper'

describe "Registration" do
  before do
    visit('/')
  end
  context "when not signed up" do
    it "should have sign up button" do
      page.should have_content("Signup now!")
    end
    
    context "clicking 'Signup now!'" do
      before do
        click_link("Signup now!")
        current_path.should == register_path       
      end
      
      context "filling out form with valid attributes" do
        before do
          register
        end
        
        it "should create a new user" do
          @user.should be_present
          @user.should_not be_is_parent
        end
        
        it "should take us to the right page" do
          current_path.should == account_path
          #save_and_open_page
          page.should have_content("Registration successful.")
        end
        
        context "logging in" do
          before do
            click_link("Logout")
            page.should have_content("Logout successful!")
            current_path.should == '/'
          end
          
          it "with valid username and password" do
            fill_in "user_session[username]", :with => "Moogles"
            fill_in "user_session[password]", :with => "password"
            click_button "Login"
          #save_and_open_page
            page.should have_content("Successfully logged in.")
          end
        end
      end
      
      context "filling out form with valid attributes as parent" do
        before do
          register(:is_parent => true)
        end
        
        it "should create a new user who is a parent" do
          @user.should be_present
          @user.should be_is_parent
        end
        
        it "should take us to the right page" do
          current_path.should == account_path
          #debugger
          #/Users/jenmei/workspace/bc/driveless/app/views/layouts/application.html.haml:38
          #save_and_open_page

          page.should have_content("Registration successful.")
        end
      end
    end
  end
  
  context "when signed up, logging in" do
    it "should have Login button" do
      page.should have_content("Login")
    end
    
    it "should have 'Forgot Your Password?' button" do
      page.should have_content("Forgot your password?")
    end
  end
end

def register(args={})
  fill_in "user[username]", :with => "Moogles"
  fill_in "user[email]", :with => "moogles@example.com"
  fill_in "user[name]", :with => "Moog"
  fill_in "user[address]", :with => "930 Cement St"
  fill_in "user[city]", :with => "New City"
  fill_in "user[zip]", :with => "94102"
  check "user[is_13]"
  check "user[is_parent]" if args[:is_parent] == true
  check "user[read_privacy]"
  fill_in "user[password]", :with => "password"
  fill_in "user[password_confirmation]", :with => "password"
  click_button "Register"
  @user = User.find_by_email('moogles@example.com')
end
