# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RandomPhoneNavigator do
  let(:factories) { TestFactories.new }
  let(:user) { factories.users.create }

  describe '#current' do
    # rubocop:disable RSpec/ExampleLength
    it 'returns a random user phone to call' do
      another_user = factories.users.create

      territories = []
      territories << factories.territories.create(user: user)
      territories << factories.territories.create(user: user)

      wanted = []
      wanted << factories.phones.create(
        action_code: PhoneAction::CODES[:call],
        last_called_at: 1.day.ago,
        territory: territories[0]
      ).id

      wanted << factories.phones.create(
        action_code: PhoneAction::CODES[:call],
        last_called_at: 1.day.ago,
        territory: territories[1]
      ).id

      wanted << factories.phones.create(
        action_code: PhoneAction::CODES[:call],
        last_called_at: nil,
        territory: territories[1]
      ).id

      # too recent
      factories.phones.create(
        action_code: PhoneAction::CODES[:call],
        last_called_at: 1.hour.ago,
        territory: territories[0]
      )

      # different status code
      factories.phones.create(
        action_code: PhoneAction::CODES[:return_visit],
        last_called_at: 1.day.ago,
        territory: territories[0]
      )

      # other user's
      factories.phones.create(
        action_code: PhoneAction::CODES[:call],
        last_called_at: 1.day.ago,
        territory: factories.territories.create(user: another_user)
      ).id

      collected = []
      10.times do
        id = described_class.new(user).current.id
        collected << id
        expect(id).to be_in(wanted)
      end

      expect(collected.uniq.length).not_to be(1)
      expect(described_class.new(user).send(:query).map(&:id).sort).to eq(wanted)
    end
    # rubocop:enable RSpec/ExampleLength

    it 'raises error when a phone cannot be found' do
      expect do
        described_class.new(user).current
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
