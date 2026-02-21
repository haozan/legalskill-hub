FactoryBot.define do
  factory :skill do
    title { "MyString" }
    description { "MyText" }
    price { 9.99 }
    association :category
    author_name { "MyString" }
    template_count { 1 }
    download_count { 1 }
    rating { 4.5 }
    slug { "MyString" }
  end
end
