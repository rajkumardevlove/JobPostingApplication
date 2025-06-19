class Job < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :applications

  # Validations
  validates :title, :description, :company_name, :location, presence: true

  # (7.0) Example: encrypts ssn
  # encrypts :ssn

  # (7.1) Example: encrypts with at_work: true
  # encrypts :body, at_work: true

  # Composite Primary Keys (commented)
  # self.primary_keys = :id, :date
end
