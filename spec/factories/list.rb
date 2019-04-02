
FactoryBot.define do
  factory :list do
    title { FFaker::Skill.specialty }
  end
end
