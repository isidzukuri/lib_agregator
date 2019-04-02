
FactoryBot.define do
  factory :article do
    title { FFaker::LoremUA.words.join(' ') }
    description { FFaker::LoremUA.sentence }
    text { FFaker::LoremUA.paragraph }
  end
end
