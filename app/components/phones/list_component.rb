# frozen_string_literal: true

class Phones::ListComponent < ApplicationComponent
  attr_reader :phones

  def initialize(phones:, territory: nil, vcards: false)
    @territory = territory
    @phones = phones
    @vcards = vcards
  end

  def vcards?
    @vcards
  end

  def vcards_path
    vcards_territory_phones_path(@territory)
  end
end
