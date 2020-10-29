class Solved < ApplicationRecord
  belongs_to :user
  belongs_to :problem

  validates :user_id, presence: true
  validates :problem_id, presence: true
  validates :first_score, presence: true
  validates :user_id, uniqueness: { scope: :problem_id }
end
