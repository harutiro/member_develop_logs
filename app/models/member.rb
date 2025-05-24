class Member < ApplicationRecord
  has_many :work_logs, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
end 