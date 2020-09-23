class Problem < ApplicationRecord
  validates :rank, presence: true
  validates :number, presence: true
  validates :name, presence: true
  validates :url, presence: true
  validates :difficulty, presence: true

  def self.parse_title(title)
    regex = /(?<rank>[A-D,S])(?<number>\d{3}):(?<name>.*)/
    m = regex.match(title)
    [m[:rank], m[:number].to_i, m[:name]]
  end

  def self.get_url_from_id(id)
    "https://paiza.jp/challenges/#{id}/ready"
  end
end
