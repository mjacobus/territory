# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhoneNumber do
  let(:number) { described_class.new('(41) 1234-1234') }

  describe '#sanitized' do
    it 'only returns numbers' do
      sanitized = number.with_prefix('014').sanitized

      expect(sanitized).to eq('0144112341234')
    end
  end

  describe '#without_area_code' do
    let(:number) { described_class.new('(41) 11234-1234') }

    it 'only returns numbers' do
      sanitized = number.without_area_code

      expect(sanitized).to eq('112341234')
    end
  end
end
