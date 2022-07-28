# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArrayNavigator do
  subject(:navigator) { described_class.new(values, current:) }

  let(:values) { %w[a b c d e] }
  let(:current) { 'c' }

  describe '#current' do
    it 'returns current' do
      expect(navigator.current).to eq('c')
    end

    context 'when current is invalid' do
      let(:current) { 'something else' }

      it 'returns first' do
        expect(navigator.current).to eq('a')
      end
    end
  end

  describe '#next' do
    it 'returns next item' do
      expect(navigator.next).to eq('d')
    end

    context 'when current is last' do
      let(:current) { 'e' }

      it 'returns first' do
        expect(navigator.next).to eq('a')
      end
    end
  end

  describe '#previous' do
    it 'returns next item' do
      expect(navigator.previous).to eq('b')
    end

    context 'when current is first' do
      let(:current) { 'a' }

      it 'returns last' do
        expect(navigator.previous).to eq('e')
      end
    end
  end
end
