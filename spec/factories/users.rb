FactoryBot.define do
  factory :user do
    name { 'Alice' }
    # email { 'alice@example.com' }
    sequence(:email) { |i| "tester#{i}@example.com" }
    password { 'hogehoge' }

    factory :other_user do
      name { 'Bob' }
    end
  end
end
