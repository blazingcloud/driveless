class NotificationsMailer < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.join_invitation.subject
  #
  def join_invitation(user, invitation)
    @invitation = invitation
    @user = user

    mail(
      :from => "#{user.name} <#{user.email}>", 
      :to => "#{invitation.name} <#{invitation.email}>", 
      :subject => "You're invited to Drive Less by #{user.name}"
    )  
  end
  
  def friendships_notification(user, friend)
    @friend = friend
    @user = user
    
    mail(
      :from => "#{user.name} <#{user.email}>", 
      :to => "#{friend.name} <#{friend.email}>", 
      :subject => "#{user.username} added you as a friend",
      :body => "Hello Acme Supply,"
    )
  end
  
  def password_reset_instructions(user)
    @user = user
    
    mail(
      :from => "#{user.name} <#{user.email}>", 
      :to => "#{user.name} <#{user.email}>", 
      :subject => "Password reset for #{user.username}.",
      :body => "Hello Wile E. Coyote,"
    )
  end
end
