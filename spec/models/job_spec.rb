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


#copilot

# require 'rails_helper'

# RSpec.describe Job, type: :model do
#   # Create test objects
#   let(:user) { create(:user) }
#   let(:job) { create(:job, user: user) }
  
#   describe "associations" do
#     it { should belong_to(:user) }
#     it { should have_many(:applications) }
#   end
  
#   describe "database columns" do
#     it "has the expected database columns" do
#       # Add your actual columns here - these are examples
#       should have_db_column(:title).of_type(:string)
#       should have_db_column(:description).of_type(:text)
#       should have_db_column(:user_id).of_type(:integer)
#       # For encrypted columns (when uncommented)
#       # should have_db_column(:ssn_ciphertext).of_type(:text)
#       # should have_db_column(:body_ciphertext).of_type(:text)
#     end
#   end

#   describe "validations" do
#     # Add tests for any validations your model has
#     # For example:
#     # it { should validate_presence_of(:title) }
#     # it { should validate_presence_of(:description) }
#   end

#   describe "encryption" do
#     context "when encrypted attributes are enabled" do
#       it "would support ssn encryption" do
#         # This is a placeholder test since encryption is commented out
#         # When you uncomment the encryption lines, you can test like this:
#         #
#         # sensitive_value = "123-45-6789"
#         # job = create(:job, ssn: sensitive_value)
#         # expect(job.ssn).to eq(sensitive_value)
#         # expect(job.ssn_ciphertext).not_to eq(sensitive_value)
#         # expect(job.ssn_ciphertext).not_to be_nil
#       end
      
#       it "would support body encryption with at_work option" do
#         # Similar placeholder for the at_work encryption feature
#         #
#         # text = "Confidential information"
#         # job = create(:job, body: text)
#         # expect(job.body).to eq(text)
#         # expect(job.body_ciphertext).not_to eq(text)
#       end
#     end
#   end

#   describe "primary key" do
#     it "uses the default primary key" do
#       expect(Job.primary_key).to eq("id")
#     end
    
#     it "would support composite primary keys when enabled" do
#       # This is a placeholder test for the commented feature
#       #
#       # If you uncomment the composite primary key lines and add the gem,
#       # you could test like this:
#       #
#       # expect(Job.primary_keys).to eq([:id, :date])
#     end
#   end

#   describe "scopes and class methods" do
#     # Add tests for any scopes or class methods your model has
#     # For example:
#     #
#     # describe ".recent" do
#     #   it "returns jobs created in the last week" do
#     #     old_job = create(:job, created_at: 2.weeks.ago)
#     #     new_job = create(:job, created_at: 3.days.ago)
#     #     expect(Job.recent).to include(new_job)
#     #     expect(Job.recent).not_to include(old_job)
#     #   end
#     # end
#   end

#   describe "instance methods" do
#     # Add tests for any instance methods your model has
#     # For example:
#     #
#     # describe "#active?" do
#     #   it "returns true when the job is active" do
#     #     job = create(:job, status: 'active')
#     #     expect(job.active?).to be true
#     #   end
#     #
#     #   it "returns false when the job is not active" do
#     #     job = create(:job, status: 'closed')
#     #     expect(job.active?).to be false
#     #   end
#     # end
#   end
# end