# frozen_string_literal: true

class Phones::RegisterOutcomeComponent < ApplicationComponent
  has :territory
  has :phone
  has :outcome

  def url
    create_territory_phone_call_attempts_path(
      territory,
      phone,
      request.query_parameters.merge(outcome: outcome).symbolize_keys
    )
  end

  def text
    t("app.outcomes.#{get(:outcome)}")
  end
end
