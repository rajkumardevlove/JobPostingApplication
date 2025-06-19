require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with all required attributes' do
      user = User.new(
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        role: 'admin'
      )

      expect(user).to be_valid
    end

    it 'is invalid without an email' do
      user = User.new(
        email: nil,
        password: 'password123',
        password_confirmation: 'password123',
        role: 'admin'
      )

      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid without a password' do
      user = User.new(
        email: 'test@example.com',
        password: nil,
        password_confirmation: nil,
        role: 'admin'
      )

      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'is invalid without a role' do
      user = User.new(
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        role: nil
      )

      expect(user).to_not be_valid
      expect(user.errors[:role]).to include("can't be blank")
    end

    it 'is invalid with a role not in ROLES' do
      user = User.new(
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        role: 'guest'
      )

      expect(user).to_not be_valid
      expect(user.errors[:role]).to include('is not included in the list')
    end
  end

  describe 'associations' do
    it { should have_many(:jobs) }
    it { should have_many(:applications) }
  end

  describe '#admin?' do
    it 'returns true if role is admin' do
      user = User.new(role: 'admin')
      expect(user.admin?).to be true
    end

    it 'returns false if role is not admin' do
      user = User.new(role: 'user')
      expect(user.admin?).to be false
    end
  end

  describe '#user?' do
    it 'returns true if role is user' do
      user = User.new(role: 'user')
      expect(user.user?).to be true
    end

    it 'returns false if role is not user' do
      user = User.new(role: 'admin')
      expect(user.user?).to be false
    end
  end
end
