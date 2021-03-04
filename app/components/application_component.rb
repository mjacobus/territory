# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  def initialize(options = {})
    @options = options
  end

  def time_ago(time)
    "#{time_ago_in_words(time)} atrás"
  end

  private

  def get(key)
    @options[key]
  end
end
