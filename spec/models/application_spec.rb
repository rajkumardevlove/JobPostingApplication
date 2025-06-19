# spec/models/application_spec.rb
require 'rails_helper'

RSpec.describe Application, type: :model do
  let(:user) { create(:user) }      # assumes you have a :user factory
  let(:job)  { create(:job) }       # assumes you have a :job factory

  subject(:application) { described_class.new(user: user, job: job) }

  context "when all required associations are present" do
    it "is valid" do
      expect(application).to be_valid
    end
  end

  context "when missing the user" do
    before { application.user = nil }

    it "is invalid" do
      expect(application).to_not be_valid
      expect(application.errors[:user]).to include("must exist")
    end
  end

  context "when missing the job" do
    before { application.job = nil }

    it "is invalid" do
      expect(application).to_not be_valid
      expect(application.errors[:job]).to include("must exist")
    end
  end
end
