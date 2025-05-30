require 'rails_helper'

RSpec.describe Job, type: :model do
  it "is valid with valid attributes" do
    job = build(:job)  # uses FactoryBot factory
    expect(job).to be_valid
  end
end