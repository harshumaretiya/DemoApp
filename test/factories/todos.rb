FactoryBot.define do
  factory :todo do
    title { "MyString" }
    desc { "MyText" }
    status { "MyString" }
    user { nil }
  end
end
