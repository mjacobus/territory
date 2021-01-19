# frozen_string_literal: true

class ArrayNavigator
  attr_reader :current

  def initialize(values, current: 'c')
    @values = values
    @current = values.include?(current) ? current : values.first
  end

  def previous
    index = @values.index(@current)
    previous_value = @values[index - 1]
    if previous_value.nil?
      previous_value = @values.first
    end
    previous_value
  end

  def next
    index = @values.index(current)
    next_element = @values[index + 1]

    if next_element.nil?
      return @values.first
    end

    next_element
  end
end
