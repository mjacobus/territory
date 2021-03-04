# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  def time_ago(time)
    "#{time_ago_in_words(time)} atrás"
  end
end
