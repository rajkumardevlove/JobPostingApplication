class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Our Platform")
  end
end

# 19 Deliver later using ActionMailer::DeliveryJob in Rails 6.1
UserMailer.welcome_email(user).deliver_later

# ActionMailer::MailDeliveryJob in Rails 7.0
# UserMailer.with(user: user, custom_subject: "Hello!").welcome_email.deliver_later