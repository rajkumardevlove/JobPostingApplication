#chat GPT

require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:applications) }
  end

  describe 'encryption' do
    let(:job) { build(:job, ssn: '123-45-6789', body: 'secret text') }

    it 'encrypts ssn on save' do
      job.save!
      expect(job.encrypted_ssn).to be_present
      expect(job.encrypted_ssn).not_to eq '123-45-6789'
      expect(job.ssn).to eq '123-45-6789'
    end

    it 'encrypts body on save and retrieves plain text' do
      job.save!
      expect(job.encrypted_body).to be_present
      expect(job.encrypted_body).not_to eq 'secret text'
      expect(job.body).to eq 'secret text'
    end
  end

  describe 'primary key' do
    it 'defaults primary_key to id' do
      expect(Job.primary_key).to eq 'id'
    end
  end
end
