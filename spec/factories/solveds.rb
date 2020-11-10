FactoryBot.define do
  factory :solved do
    association :user
    association :problem
  end
end
