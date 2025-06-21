class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :total_development_time, :level

  has_many :development_times
  has_many :achievements
end
