
FactoryBot.define do
  factory :book do
    title { FFaker::Book.title }
  end
end
