# Devise Configuration
  ActionMailer::Base.smtp_settings = {
  :port           => 587,
  :address        => "smtp.gmail.com",
  :user_name      => "cp.lunch.roulette@gmail.com",
  :password       => "dlhrodlhro",
  :domain         => 'cp-lunch-roulette.heroku.com',
  :authentication => :plain,
}
  ActionMailer::Base.delivery_method = :smtp
