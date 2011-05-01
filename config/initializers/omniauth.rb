Rails.application.config.middleware.use OmniAuth::Builder do    
  provider :facebook, 'f4d437b757f1f8a88c1ab4c7e4fd3077', '2b057ad872df6915ff2f861eeb577a5a'
end