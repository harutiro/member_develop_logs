class DevelopmentTime < ApplicationRecord
  belongs_to :user

  validates :start_time, presence: true
  validates :end_time, presence: true, on: :update
  validates :duration, presence: true, numericality: { greater_than: 0 }, on: :update
  validate :end_time_after_start_time, if: -> { end_time.present? }

  before_validation :calculate_duration

  private

  def calculate_duration
    return unless start_time && end_time
    self.duration = (end_time - start_time).to_i
  end

  def end_time_after_start_time
    return unless start_time && end_time
    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end
