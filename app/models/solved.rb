class Solved < ApplicationRecord
  belongs_to :user
  belongs_to :problem

  validates :user_id, presence: true
  validates :problem_id, presence: true

  validates :solved_at, uniqueness: { scope: [:user_id, :problem_id] }
end
