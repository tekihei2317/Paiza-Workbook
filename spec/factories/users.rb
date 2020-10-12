FactoryBot.define do
  factory :user do
    name { 'Alice' }
    email { 'alice@example.com' }
    password { 'hogehoge' }
  end
end
