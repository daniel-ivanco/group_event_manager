FactoryBot.define do
  factory :group_event do
    start_date { Date.today }
    end_date { Date.tomorrow }
    duration { 1 }
    name { 'test 1' }
    description  { 'test desc 1' }
    published { false }
    enabled { true }
    latitude { 51.08804 }
    longitude { 15.42076 }

    trait :next_day do
      start_date { Date.today + 1 }
      end_date { Date.tomorrow + 2 }
      duration { 2 }
      name { 'test 2' }
      description  { 'test desc 2' }
    end

    trait :disabled do
      enabled { false }
    end
  end
end
