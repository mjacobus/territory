# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PhoneAction do
  let(:action) { described_class.new(code) }

  describe '#to_s' do
    subject { action.to_s }

    context 'when code is 0' do
      let(:code) { 0 }

      it { is_expected.to eq('call') }
    end

    context 'when code is 1' do
      let(:code) { 1 }

      it { is_expected.to eq('return_visit') }
    end

    context 'when code is 2' do
      let(:code) { 2 }

      it { is_expected.to eq('forget') }
    end

    context 'when code is 3' do
      let(:code) { 3 }

      it { is_expected.to eq('verify') }
    end
  end

  describe '#localized' do
    subject { action.localized }

    context 'when code is 0' do
      let(:code) { 0 }

      it { is_expected.to eq('Ligar') }
    end

    context 'when code is 1' do
      let(:code) { 1 }

      it { is_expected.to eq('Revisitar') }
    end

    context 'when code is 2' do
      let(:code) { 2 }

      it { is_expected.to eq('Esquecer') }
    end

    context 'when code is 3' do
      let(:code) { 3 }

      it { is_expected.to eq('Verificar') }
    end
  end
end
