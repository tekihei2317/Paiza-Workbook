FactoryBot.define do
  # テストのために実際の問題は登録しているので、架空の問題を使う
  factory :problem do
    rank { 'S' }
    number { 999 }
    name { '団長からの挑戦状' }
    url { 'https://paiza.jp/challenges/9999/ready' }
    difficulty { 9999 }

    factory :other_problem do
      rank { 'S' }
      number { 888 }
      name { '師匠からの試練' }
      url { 'https://paiza.jp/challenges/8888/ready' }
      difficulty { 8888 }
    end
  end
end
