# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PhoneDecorator do
  let(:phone) do
    Phone.new(number: 'the-number', id: '1', return_visit: return_visit)
  end
  let(:return_visit) { nil }
  let(:decorator) { described_class.new(phone) }
  # rubocop:disable RSpec/VerifiedDoubles
  let(:call_attempts) { double(:call_attempts) }
  # rubocop:enable RSpec/VerifiedDoubles
  let(:pluck_args) do
    %i[
      name
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

  describe '#status' do
    context 'when never called' do
      let(:plucked) { [] }

      it 'returns never called' do
        expect(decorator.status).to eq('never_called')
      end
    end

    context 'when not home' do
      let(:plucked) { [%w[name not_home]] }

      it 'returns not home' do
        expect(decorator.status).to eq('not_home')
      end
    end

    context 'when should return visit' do
      let(:plucked) { [%w[name not_home]] }
      let(:return_visit) { true }

      it 'returns contact_again' do
        expect(decorator.status).to eq('contact_again')
      end
    end

    context 'when should not return visit' do
      let(:plucked) { [%w[name not_home]] }
      let(:return_visit) { false }

      it 'returns do_not_contact_again' do
        expect(decorator.status).to eq('do_not_contact_again')
      end
    end

    context 'when information is missing' do
      let(:plucked) { [%w[name contacted]] }
      let(:return_visit) { nil }

      it 'returns error' do
        expect(decorator.status).to eq('error')
      end
    end
  end
end
