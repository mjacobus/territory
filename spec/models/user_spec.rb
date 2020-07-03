# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:factories) { TestFactories.new }

  describe '#return_visits' do
    it 'returns only return visits of the user' do
      user1 = factories.users.create
      user2 = factories.users.create

      phone = factories.call_attempts.create_return_visit(user: user1).phone
      expected = factories.call_attempts.create_return_visit(user: user1, phone: phone)

      factories.call_attempts.create_not_home(phone: expected.phone, user: user2)
      factories.call_attempts.create_return_visit(user: user2)

      phone.update_status

      expect(user1.return_visits).to eq([expected.phone])
    end
  end
end
