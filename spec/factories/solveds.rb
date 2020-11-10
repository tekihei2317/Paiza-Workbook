FactoryBot.define do
  factory :solved do
    first_score { 100 }
    association :user
    association :problem
  end
end
