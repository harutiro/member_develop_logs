class AvatarTransformation < ApplicationRecord
  belongs_to :mentor_avatar

  validates :trigger_type, presence: true
  validates :trigger_value, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :transformation_date, presence: true

  TRIGGER_TYPES = %w[
    total_hours
    achievement_count
    bug_fix
    feature_implementation
    learning
    project_completion
    code_review
    surprise
  ].freeze

  validates :trigger_type, inclusion: { in: TRIGGER_TYPES }

  def self.record_transformation(mentor_avatar, trigger_type, trigger_value)
    create!(
      mentor_avatar: mentor_avatar,
      trigger_type: trigger_type,
      trigger_value: trigger_value,
      transformation_date: Time.current
    )
  end
end
