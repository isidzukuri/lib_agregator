
FactoryBot.define do
  factory :tag do
    title { FFaker::Skill.specialty }
    uk { FFaker::Skill.specialty }
  end
end
