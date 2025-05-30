FactoryBot.define do
  factory :job do
    title { "Software Dveloper" }
    company_name { "Acme Corp" }
    location { "Remote" }
    description { "Build and maintain Rails applications" }
    association :user   # This links job.user to a created user automatically
  end
end