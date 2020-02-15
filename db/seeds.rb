# frozen_string_literal: true

1.upto(20) do |n|
  n = n.to_s.rjust(2, '0')
  Territory.find_or_create_by!(name: "T-#{n}")

  user = User.find_or_create_by!(
    name: "User #{n}",
  )

  user.master = (rand(5) % 5).zero?
  user.enabled = (rand(5) % 5).zero?
  user.save
end
