# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Phone, type: :model do
  let(:phone) { described_class.new(number: 'some-number', territory: territory) }
  let(:territory) { Territory.new(name: 'T1') }

  it 'belongs to territory' do
    expect(phone.territory).to eq(territory)
  end

  context 'when quering for previous' do
    before do
      territory.save!

      %w[a b c d e f].shuffle.each do |number|
        described_class.create!(number: number, territory: territory)
      end
    end

    it 'finds next and when there is one' do
      phone = described_class.find_by_number('c').next

      expect(phone.number).to eq('d')
    end

    it 'returns first when there is no next' do
      phone = described_class.find_by_number('f').next

      expect(phone.number).to eq('a')
    end

    it 'finds previous and when there is one' do
      phone = described_class.find_by_number('c').previous

      expect(phone.number).to eq('b')
    end

    it 'returns first when there is no previous' do
      phone = described_class.find_by_number('a').previous

      expect(phone.number).to eq('f')
    end
  end

  describe '#format_number' do
    it 'removes any non-number char' do
      formatted = described_class.new(number: '(41) 1234-1234').format_number(prefix: '014')

      expect(formatted).to eq('0144112341234')
    end
  end
end
