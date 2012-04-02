require 'spec_helper'
describe FriendshipsController do
  include Devise::TestHelpers
  context "when signed in" do
    before do
      sign_in User.make
    end
    context "with new friendship" do
      context "a mail error" do
        it "fills in the flash messages with notice" do
          stub(User).friendship_to { raise User::MailError }

          post :create , :friend_id => 'fake'

          response.should be_redirect
          flash[:notice].should match(/Error/)
        end
      end

      context "successful" do
        it " redirects " do
          post :create , :friend_id => '1'

          response.should be_redirect
          flash[:notice].should == nil
        end
      end
    end
  end
end
