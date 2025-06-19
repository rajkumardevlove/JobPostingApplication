class User < ApplicationRecord
  has_many :jobs
  has_many :applications
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar

  ROLES = %w[admin user].freeze

  validates :role, presence: true, inclusion: { in: ROLES }

  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end
end
