class Assignment < ApplicationRecord
  belongs_to :course
  has_many :test_reps
end
