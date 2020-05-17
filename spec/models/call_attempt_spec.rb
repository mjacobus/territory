# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CallAttempt, type: :model do
  let(:factories) { TestFactories.new }
  let(:factory) { factories.call_attempts }
  let(:phone) { Phone.new }
  let(:attempt) { described_class.new(phone: phone, user: User.new) }
  let(:contacted) do
    factory.build(
      phone: phone,
      outcome: 'contacted',
      user: User.new,
      gender: 'male',
      notes: 'nice talk'
    )
  end

  it 'defaults return_visit nil' do
    expect(contacted.return_visit).to be nil
  end

  it 'belongs to phone' do
    expect(attempt.phone).to eq(phone)
  end

  it 'accepts not_home as an outcome' do
    attempt.outcome = 'not_home'

    expect(attempt).to be_valid
  end

  it 'accepts contacted as an outcome' do
    attempt.outcome = 'contacted'
    attempt.notes = 'something'
    attempt.gender = 'male'

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

  it 'is valid with no extra data when outcome is not_home' do
    attempt.outcome = 'not_home'
    attempt.gender = ''

    expect(attempt).to be_valid
  end

  it 'is valid with no extra data when outcome is disconnected' do
    attempt.outcome = 'disconnected'
    attempt.gender = ''

    expect(attempt).to be_valid
  end

  it 'is valid with no extra data when outcome is unreachable' do
    attempt.outcome = 'unreachable'
    attempt.gender = ''

    expect(attempt).to be_valid
  end

  it 'requires gender when person was contacted' do
    attempt.outcome = 'contacted'
    attempt.gender = ''

    expect(attempt).not_to be_valid
    expect(attempt.errors[:gender]).not_to be_empty
  end

  it 'requires notes when person was contacted' do
    attempt.outcome = 'contacted'
    attempt.notes = ''

    expect(attempt).not_to be_valid
    expect(attempt.errors[:notes]).not_to be_empty
  end

  it 'accepts male as #gender' do
    contacted.gender = 'male'

    expect(contacted).to be_valid
  end

  it 'accepts female as #gender' do
    contacted.gender = 'female'

    expect(contacted).to be_valid
  end

  it 'rejects invalid #gender' do
    contacted.gender = 'other'

    expect(contacted).not_to be_valid
  end

  describe '#return_visit' do
    context 'when transitioning to return_visit to not_home' do
      it 'stays true' do
        phone = factories.phones.create

        factory.create_return_visit(phone: phone)
        factory.create_not_home(phone: phone)

        expect(phone.reload.return_visit).to be true
      end
    end

    context 'when transitioning to return_visit to not_home' do
      it 'changes to false' do
        phone = factories.phones.create

        factory.create_return_visit(phone: phone)
        factory.create_do_not_call(phone: phone)

        expect(phone.reload.return_visit).to be false
      end
    end

    context 'when transitioning to do_not_visit to not_home' do
      it 'changes to false' do
        phone = factories.phones.create

        factory.create_do_not_call(phone: phone)
        factory.create_not_home(phone: phone)

        expect(phone.reload.return_visit).to be false
      end
    end
  end
end
