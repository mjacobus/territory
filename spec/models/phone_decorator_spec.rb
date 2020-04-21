# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PhoneDecorator do
  let(:phone) do
    Phone.new(number: 'the-number', id: '1')
  end
  let(:decorator) { described_class.new(phone) }
  # rubocop:disable RSpec/VerifiedDoubles
  let(:call_attempts) { double(:call_attempts) }
  # rubocop:enable RSpec/VerifiedDoubles
  let(:pluck_args) do
    %i[
      name
      can_call_again
      can_text
      outcome
    ]
  end
  let(:plucked) { [] }

  before do
    allow(phone).to receive(:call_attempts).and_return(call_attempts)
    allow(call_attempts).to receive(:pluck).with(*pluck_args).and_return(plucked)
  end

  it 'responds to all read attributes of phone' do
    expect(decorator.number).to eq('the-number')
    expect(decorator.to_param).to eq('1')
  end

  describe '#contact_name' do
    let(:plucked) do
      [
        ['John'],
        ['John'],
        [''],
        [nil],
        ['Mary']
      ]
    end

    it 'returns all possible contact names' do
      expect(decorator.contact_name).to eq('John, Mary')
    end
  end

  describe '#call_again?' do
    let(:plucked) do
      [
        [nil, nil],
        [nil, ''],
        [nil, true],
        [nil, nil],
        [nil, last],
        [nil, '']
      ]
    end

    context 'when last answer is no' do
      let(:last) { false }

      it 'returns false' do
        expect(decorator.call_again?).to be last
      end
    end

    context 'when last answer is yes' do
      let(:last) { true }

      it 'returns true' do
        expect(decorator.call_again?).to be last
      end
    end

    context 'when last answer absent' do
      let(:plucked) { [[nil, nil]] }

      it 'returns true' do
        expect(decorator.call_again?).to be true
      end
    end

    context 'when there was no answer' do
      let(:plucked) { [] }

      it 'returns true' do
        expect(decorator.call_again?).to be true
      end
    end
  end

  describe '#can_text?' do
    let(:plucked) do
      [
        [nil, nil, nil],
        [nil, nil, ''],
        [nil, nil, true],
        [nil, nil, nil],
        [nil, nil, last],
        [nil, nil, '']
      ]
    end

    context 'when last answer is no' do
      let(:last) { false }

      it 'returns false' do
        expect(decorator.can_text?).to be last
      end
    end

    context 'when last answer is yes' do
      let(:last) { true }

      it 'returns true' do
        expect(decorator.can_text?).to be last
      end
    end

    context 'when last answer absent' do
      let(:plucked) { [[nil, nil]] }

      it 'returns true' do
        expect(decorator.can_text?).to be true
      end
    end

    context 'when there was no answer' do
      let(:plucked) { [] }

      it 'returns true' do
        expect(decorator.can_text?).to be true
      end
    end
  end
end
