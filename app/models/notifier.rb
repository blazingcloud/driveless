class Notifier < ActionMailer::Base
  default_url_options[:host] = "driveless.heroku.com"

  def password_reset_instructions(user)
    subject       "Password Reset for Driveless "
    from          "Driveless Challenge <noreply@driveless.heroku.com>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  def friendship_notification(user, friend)
    subject       "#{user.username} added you as a friend"
    from          "Driveless Challange <noreply@driveless.heroku.com>"
    recipients    friend.email
    sent_on       Time.now
    body          :friend_username => user.username, :friend_url => user_url( user )
  end

end
