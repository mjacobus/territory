# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CallAttempt, type: :model do
  let(:territory) { Phone.new(territory: territory) }
  let(:phone) { Phone.new }
  let(:attempt) { described_class.new(phone: phone, user: User.new) }

  it 'belongs to phone' do
    expect(attempt.phone).to eq(phone)
  end

  it 'accepts not_home as an outcome' do
    attempt.outcome = 'not_home'

    expect(attempt).to be_valid
  end

  it 'accepts contacted as an outcome' do
    attempt.outcome = 'contacted'

    expect(attempt).to be_valid
  end

  it 'accepts unreachable as an outcome' do
    attempt.outcome = 'unreachable'

    expect(attempt).to be_valid
  end

  it 'rejects unlisted outcomes' do
    attempt.outcome = 'something_else'

    expect(attempt).not_to be_valid
  end
end
