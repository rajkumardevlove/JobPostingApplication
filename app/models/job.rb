class Job < ApplicationRecord
  # (7.0) 1. encrypts ssn
  # encrypts :ssn
  # (7.1) 2. encrypts at_work:true
  #  encrypts :body, at_work: true
  belongs_to :user
  has_many :applications
 # 5 (rails 7.0) requires composite_primary_keys gem 
  # self.primary_keys = :id, :date
  # rails 7.1 need to declare primary keys
end