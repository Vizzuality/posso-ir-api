class UserSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash
  set_type :user

  attribute :email
  attribute :name
  attribute :reports_made do |object|
    Rails.env.production? ? object.status_crowdsource_users.count : rand(1..100)
  end
  attribute :reporter_ranking do |object|
    Rails.env.production? ? object.reporter_rank : rand(1..100)
  end

  has_many :stores, type: :stores, serializer: StoreSerializer
end
