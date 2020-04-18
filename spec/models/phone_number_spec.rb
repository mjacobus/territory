# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PhoneNumber do
  let(:number) { described_class.new('(41) 1234-1234') }

  describe '#sanitized' do
    it 'only returns numbers' do
      sanitized = number.with_prefix('014').sanitized

      expect(sanitized).to eq('0144112341234')
    end
  end
end
