class Problem < ApplicationRecord
  validates :rank, presence: true
  validates :number, presence: true
  validates :name, presence: true
  validates :url, presence: true
  validates :difficulty, presence: true
end
