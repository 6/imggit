FactoryGirl.define do
  # Model.build(:model, :id) to get fake ID
  trait :id do
    id { rand(1000000) }
  end

  factory :imgur_image do
    sequence(:remote_id) { |n| "image#{n}" }
  end

  factory :tag do
    image { FactoryGirl.build(:imgur_image) }
    sequence(:text) { |n| "tag#{n}" }
  end
end
