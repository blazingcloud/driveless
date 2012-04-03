Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '116783538335231', 'ff42ca3e3dc69b2da6e761db9133aeb3', :scope => 'email, user_about_me'
end
