# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PhoneDecorator do
  let(:phone) do
    Phone.new(number: 'the-number', id: '1')
  end
  let(:decorator) { described_class.new(phone) }
  let(:call_attempts) { double(:call_attempts) }

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
end
