FactoryGirl.define do
  factory :confirmed_user, parent: :user do
    confirmed_at { Time.now }
    confirmation_sent_at { Time.now }
    confirmation_token "12345"
  end
end