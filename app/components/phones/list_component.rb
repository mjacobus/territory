# frozen_string_literal: true

class Phones::ListComponent < ApplicationComponent
  attr_reader :header

  def initialize(phones:, territory: nil, vcards: false)
    @territory = territory
    @phones = phones
    @vcards = vcards
    super
  end

  def vcards?
    @vcards
  end

  def vcards_path
    vcards_territory_phones_path(@territory)
  end
end
