# Devise Configuration
  ActionMailer::Base.smtp_settings = {
  :port           => 587,
  :address        => "smtp.gmail.com",
  :user_name      => Rails.application.secrets.EMAIL_USER_NAME,
  :password       => Rails.application.secrets.EMAIL_PASSWORD,
  :domain         => 'cp-lunch-roulette.heroku.com',
  :authentication => :plain,
}
  ActionMailer::Base.delivery_method = :smtp
