# frozen_string_literal: true

module ApplicationHelper
  def outcome_label(outcome)
    I18n.t("app.outcomes.#{outcome}")
  end

  def gender_label(gender)
    I18n.t("app.genders.#{gender}")
  end

  def user_collection_for_select(territory)
    values = User.all.map do |user|
      ["#{user.name} (#{user.email})", user.id]
    end

    if territory.user
      user = territory.user
      values << ["#{user.name} (#{user.email})", user.id]
    end

    values.uniq
  end
end
