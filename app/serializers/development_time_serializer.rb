class DevelopmentTimeSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :duration, :notes, :created_at

  belongs_to :user
end 