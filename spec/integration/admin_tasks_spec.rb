require 'spec_helper'

describe "When user is an administrator" do
  before do
    @admin = User.make(:password => "password")
    @admin.update_attribute(:admin, true)
    @admin.reload.should be_admin
    login_as(@admin, "password")
  end

  describe "When editing a user" do
    it "should be able to make another user an admin" do
      user = User.make
      user.reload.should_not be_admin
      visit edit_user_path(user)
      check "user_admin"
      click_button "Update"
      user.reload.should be_admin
    end

    it "should be able to remove admin rights from someone" do
      user = User.make
      user.update_attribute(:admin, true)
      user.reload.should be_admin
      visit edit_user_path(user)
      uncheck "user_admin"
      click_button "Update"
      user.reload.should_not be_admin
    end
  end
end
