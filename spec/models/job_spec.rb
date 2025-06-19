require 'rails_helper'

RSpec.describe Job, type: :model do
  let(:user) { create(:user) }  # assumes you have a :user factory

  context 'validations' do
    it 'is valid with all attributes present and a user' do
      job = Job.new(
        title:        "Rails Engineer",
        description:  "Build and maintain Rails apps",
        company_name: "Acme Inc",
        location:     "Tokyo",
        user:         user
      )

      expect(job).to be_valid
    end

    it 'is invalid without a user' do
      job = Job.new(
        title:        "Rails Engineer",
        description:  "Build and maintain Rails apps",
        company_name: "Acme Inc",
        location:     "Tokyo",
        user:         nil
      )

      expect(job).not_to be_valid
      expect(job.errors[:user]).to include("must exist")
    end

    it 'is invalid without a title' do
      job = Job.new(
        title:        nil,
        description:  "Some desc",
        company_name: "Acme Inc",
        location:     "Tokyo",
        user:         user
      )

      expect(job).not_to be_valid
      expect(job.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without a description' do
      job = Job.new(
        title:        "Java",
        description:  nil,
        company_name: "Acme Inc",
        location:     "Tokyo",
        user:         user
      )

      expect(job).not_to be_valid
      expect(job.errors[:description]).to include("can't be blank")
    end

    it 'is invalid without a company_name' do
      job = Job.new(
        title:        "Rails Engineer",
        description:  "Build and maintain Rails apps",
        company_name: nil,
        location:     "Tokyo",
        user:         user
      )

      expect(job).not_to be_valid
      expect(job.errors[:company_name]).to include("can't be blank")
    end

    it 'is invalid without a location' do
      job = Job.new(
        title:        "Rails Engineer",
        description:  "Build and maintain Rails apps",
        company_name: "Acme Inc",
        location:     nil,
        user:         user
      )

      expect(job).not_to be_valid
      expect(job.errors[:location]).to include("can't be blank")
    end
  end
end
