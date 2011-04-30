require "spec_helper"

describe NotificationsMailer do
  attr_reader :user, :invitation, :friend, :mail

  before do
    @user = User.make(
      :password => "changeme", 
      :name => "Wile E. Coyote",
      :email => "wile@example.com"
    )
  end

  describe "join_invitation" do

    before do
      @invitation = Invitation.create!(
        :name => "Road Runner",
        :email => "rr@example.com",
        :user => user,
        :invitation => "Please check out this great site!"
      )
      @mail = NotificationsMailer.join_invitation(user, invitation)
    end


    it "renders the headers" do
      mail.subject.should eq("You're invited to Drive Less by #{user.name}")
      mail.to.should eq(["rr@example.com"])
      mail.from.should eq(["wile@example.com"])
    end

    it "should have the invitee's name in the salutation" do
      mail.body.encoded.should match("Hello Road Runner,")
    end

     it "should have user name and link" do 
       mail.body.encoded.should match(
         "Wile E. Coyote is driving less with the Drive Less Challenge and wants you to join! " +
         "Signup at http://my.drivelesschallenge.com/users/sign_up."
       )
     end
  end
  
  describe "friendships_notification" do

    before do
      @friend = User.make(
        :password => "newpass", 
        :name => "Acme Supply",
        :email => "acme@example.com"
      )
      @mail = NotificationsMailer.friendships_notification(user, friend)
    end

    it "renders the headers" do
      mail.subject.should eq("#{user.name} added you as a friend")
      mail.to.should eq(["acme@example.com"])
    end

    it "should have the invitee's name in the salutation" do
      mail.body.encoded.should match("Hello Acme Supply,")
    end

    it "should have user name and link" do
      mail.body.encoded.should match( "Wile E. Coyote has added you as a friend!")
    end
  end

end
