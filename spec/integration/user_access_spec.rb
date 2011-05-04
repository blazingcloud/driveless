require 'spec_helper'

describe "When browsing" do

  context "as not an admin" do
    before do
      @user = User.make(:password => "password")
      login_as(@user)
    end
    it "/results should redirect to account_path" do
      visit '/results'
      current_path.should == '/account'
    end
    it "/users should redirect to account_path" do
      visit '/users'
      current_path.should == '/account'
    end
    it "/communities/new should redirect to account_path" do
      visit '/communities/new'
      current_path.should == '/account'
    end
    it "/communities/edit should redirect to account_path" do
      visit '/communities/1/edit'
      current_path.should == '/account'
    end
  end
end