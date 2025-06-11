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
