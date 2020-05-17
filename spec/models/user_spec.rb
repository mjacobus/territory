# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:factories) { TestFactories.new }

  describe '#return_visits' do
    it 'returns only return visits of the user' do
      user1 = factories.users.create
      user2 = factories.users.create

      expected = factories.call_attempts.create_return_visit(user: user1)
      factories.call_attempts.create_return_visit(user: user2)

      expect(user1.return_visits).to eq([expected.phone])
    end
  end
end
