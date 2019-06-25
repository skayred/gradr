class Submission < ApplicationRecord
  belongs_to :assignment

  enum status: [:started, :finished]
end
