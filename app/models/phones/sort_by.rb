# frozen_string_literal: true

module Phones
  class SortBy
    ALLOWED_DIRECTIONS = %w[ASC DESC].freeze
    ALLOWED_FIELDS = %w[last_contacted_at last_called_at].freeze

    def initialize(sort_string = '')
      @field, @direction = sort_string.to_s.split('.')
    end

    def to_s
      if field
        return "#{field} #{direction}".strip
      end

      ''
    end

    def field
      if ALLOWED_FIELDS.include?(@field.to_s)
        @field.to_s
      end
    end

    def direction
      if ALLOWED_DIRECTIONS.include?(@direction.to_s.upcase)
        @direction.to_s.upcase
      end
    end
  end
end
