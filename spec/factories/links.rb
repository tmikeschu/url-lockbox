FactoryBot.define do
  factory :link do
    url { Faker::Internet.url }
    title { Faker::HarryPotter.location }
    read false
    user
  end
end
