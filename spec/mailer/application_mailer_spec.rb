#chat GPT
require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe '#welcome_email' do
    let(:user) { create(:user, email: 'test@example.com') }
    let(:mail) { described_class.welcome_email(user) }

    before do
      # Ensure jobs are not actually delivered during tests
      ActiveJob::Base.queue_adapter = :test
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('Welcome to Our Platform')
      expect(mail.to).to eq(['test@example.com'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'assigns @user for the email template' do
      # Without a view template, body may be empty but instance variable is set
      expect(mail.instance_variable_get(:@user)).to eq(user)
    end

    it 'enqueues a mail delivery job with deliver_later' do
      expect {
        described_class.welcome_email(user).deliver_later
      }.to have_enqueued_mail(described_class, :welcome_email).with(user)
    end
  end
end



#copliot

# require "rails_helper"

# RSpec.describe ApplicationMailer, type: :mailer do
#   describe "#welcome_email" do
#     let(:user) { double("User", email: "user@example.com", name: "Test User") }
#     let(:mail) { ApplicationMailer.welcome_email(user) }

#     it "renders the headers" do
#       expect(mail.subject).to eq("Welcome to Our Platform")
#       expect(mail.to).to eq(["user@example.com"])
#       expect(mail.from).to eq(["from@example.com"])
#     end

#     it "assigns @user" do
#       # This verifies that the instance variable is set correctly within the mailer
#       expect(mail.instance_variable_get(:@user)).to eq(user)
#     end

#     it "renders the body" do
#       # Assuming the mailer template contains the user's name
#       # You may need to adjust this expectation based on your actual template content
#       expect(mail.body.encoded).to match(/Test User/)
#     end
#   end

#   describe "delivery methods" do
#     let(:user) { double("User", email: "user@example.com", name: "Test User") }

#     it "can be delivered later with ActionMailer::DeliveryJob in Rails 6.1" do
#       mailer = ApplicationMailer.welcome_email(user)
      
#       # Test that deliver_later enqueues the correct job
#       expect {
#         mailer.deliver_later
#       }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
#     end

#     it "correctly sets delivery job parameters" do
#       mailer = ApplicationMailer.welcome_email(user)
      
#       expect {
#         mailer.deliver_later
#       }.to have_enqueued_job.with { |job_args|
#         expect(job_args["args"][0]["mailer"]).to eq("ApplicationMailer")
#         expect(job_args["args"][0]["mail_method"]).to eq("welcome_email")
#         expect(job_args["args"][0]["args"]).to be_present
#       }
#     end
#   end
# end