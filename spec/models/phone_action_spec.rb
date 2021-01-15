# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PhoneAction do
  subject(:action) { described_class.new(phone) }

  let(:phone) { double(:phone, action_code: code) }

  describe '#to_s' do
    context 'when code is 0' do
      let(:code) { 0 }

      it 'returns call' do
        expect(action.to_s).to eq('call')
      end
    end

    context 'when code is 1' do
      let(:code) { 1 }

      it 'returns return_visit' do
        expect(action.to_s).to eq('return_visit')
      end
    end

    context 'when code is 2' do
      let(:code) { 2 }

      it 'returns forget' do
        expect(action.to_s).to eq('forget')
      end
    end

    context 'when code is 3' do
      let(:code) { 3 }

      it 'returns check' do
        expect(action.to_s).to eq('check')
      end
    end
  end
end
