FactoryBot.define do
  factory :problem do
    rank { 'D' }
    number { 166 }
    name { '何日後になるか' }
    url { 'https://paiza.jp/challenges/405/ready' }
    difficulty { 847 }

    factory :other_problem do
      rank { 'B' }
      number { 21 }
      name { '複数形への変換' }
      url { 'https://paiza.jp/challenges/77/ready' }
      difficulty { 1592 }
    end
  end
end
