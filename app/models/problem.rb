class Problem < ApplicationRecord
  has_many :solveds

  validates :rank, presence: true
  validates :number, presence: true
  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
  validates :difficulty, presence: true

  enum rank: { D: 0, C: 1, B: 2, A: 3, S: 4 }

  SELECT_OPTIONS_DIFFICULTY = [0, 800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 3000]

  def self.parse_title(title)
    regex = /(?<rank>[A-D,S])(?<number>\d{3}):(?<name>.*)/
    m = regex.match(title)
    [m[:rank], m[:number].to_i, m[:name]]
  end

  def self.get_url_from_id(id)
    "https://paiza.jp/challenges/#{id}/ready"
  end

  def average_time
    format('%02d:%02d', average_time_min, average_time_sec)
  end
end
