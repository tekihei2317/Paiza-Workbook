class Problem < ApplicationRecord
  validate :rank, presence: true
  validate :number, presence: true
  validate :name, presence: true
  validate :url, presence: true
  validate :difficulty, presence: true
end
