# frozen_string_literal: true

class BreadcrumbComponent < ApplicationComponent
  Item = Struct.new(:text, :url, :last)

  def initialize(items = [])
    @items = items
  end

  def each(&block)
    mapped.each(&block)
  end

  def items
    @items
  end

  def add(text, url = nil)
    @items << [text, url]
    self
  end

  private

  def mapped
    items.map.with_index do |item, index|
      last = (index + 1) == items.length
      Item.new(item[0], item[1], last)
    end
  end
end
