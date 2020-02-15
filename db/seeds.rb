# frozen_string_literal: true

1.upto(20) do |n|
  n = n.to_s.rjust(2, '0')
  Territory.find_or_create_by!(name: "T-#{n}")
end
