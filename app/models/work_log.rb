class WorkLog < ApplicationRecord
  belongs_to :member

  validates :start_time, presence: true
  validates :end_time, presence: true, unless: :active?
  validate :end_time_after_start_time

  def duration
    return ((Time.current - start_time) / 3600).round(2) if active?
    ((end_time - start_time) / 3600).round(2)
  end

  def active?
    end_time.nil?
  end

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "は開始時間より後の時間を指定してください")
    end
  end
end
