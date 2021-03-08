# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  MissingArgument = Class.new(StandardError)

  def self.has(field, public: false)
    define_method field do
      get(field) || raise(MissingArgument, "Missing argument: #{field}")
    end
    unless public
      private field
    end
  end

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
