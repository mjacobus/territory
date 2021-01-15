# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PhoneStatus do
  subject(:status) { described_class.new(phone) }

  let(:outcomes) { [] }
  let(:return_visit) { nil }
  let(:phone) do
    instance_double(
      PhoneDecorator,
      outcomes: outcomes,
      return_visit: return_visit,
      return_visit?: return_visit
    )
  end

  describe '#to_s' do
    context 'when never called' do
      it 'returns never called' do
        expect(status.to_s).to eq('never_called')
      end
    end

    context 'when not home' do
      let(:outcomes) { %w[not_home] }

      it 'returns not home' do
        expect(status.to_s).to eq('not_home')
      end
    end

    context 'when should return visit' do
      let(:return_visit) { true }
      let(:outcomes) { %w[not_home] }

      it 'returns contact_again' do
        expect(status.to_s).to eq('contact_again')
      end
    end

    context 'when should not return visit' do
      let(:outcomes) { %w[not_home] }
      let(:return_visit) { false }

      it 'returns do_not_contact_again' do
        expect(status.to_s).to eq('do_not_contact_again')
      end
    end

    context 'when it was unreachable' do
      let(:outcomes) { %w[unreachable] }
      let(:return_visit) { nil }

      it 'returns error' do
        expect(status.to_s).to eq('unreachable')
      end
    end

    context 'when information is missing' do
      let(:outcomes) { %w[contancted] }
      let(:return_visit) { nil }

      it 'returns error' do
        expect(status.to_s).to eq('error')
      end
    end
  end
end
