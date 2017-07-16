FactoryGirl.define do
  factory :user do |user|
    user.sequence(:name) { |i| "Test#{i}" }
  end
end
