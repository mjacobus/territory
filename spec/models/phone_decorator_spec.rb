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
end
