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
end
