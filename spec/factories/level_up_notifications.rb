FactoryBot.define do
  factory :level_up_notification do
    user { nil }
    mentor_level { 1 }
    shown { false }
  end
end
