FactoryBot.define do
  factory :problem do
    rank { 'D' }
    number { 166 }
    name { '何日後になるか' }
    url { 'https://paiza.jp/challenges/405/ready' }
    difficulty { 847 }
  end
end
