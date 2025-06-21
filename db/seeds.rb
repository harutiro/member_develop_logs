# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# ユーザーのシードデータ
users = [
  { name: '山田太郎', email: 'yamada@example.com' },
  { name: '鈴木花子', email: 'suzuki@example.com' },
  { name: '佐藤次郎', email: 'sato@example.com' }
]

users.each do |user_data|
  User.find_or_create_by!(email: user_data[:email]) do |user|
    user.name = user_data[:name]
    user.total_development_time = 0
    user.level = 1
  end
end

# メンバーのシードデータ
members = [
  { name: '山田太郎' },
  { name: '鈴木花子' },
  { name: '佐藤次郎' }
]

members.each do |member_data|
  Member.find_or_create_by!(name: member_data[:name])
end

# 作業ログのシードデータ
member = Member.first
if member
  # 今日の作業ログ
  WorkLog.create!(
    member: member,
    start_time: Time.current.beginning_of_day + 9.hours,
    end_time: Time.current.beginning_of_day + 18.hours
  )

  # 昨日の作業ログ
  WorkLog.create!(
    member: member,
    start_time: 1.day.ago.beginning_of_day + 9.hours,
    end_time: 1.day.ago.beginning_of_day + 17.hours
  )
end

# 各ユーザーにmentor_avatarを作成
MentorAvatar.find_or_create_by!(
  name: "はじめのメンター",
  description: "はじめのメンター",
  level: 1
)

puts 'シードデータの作成が完了しました。'
