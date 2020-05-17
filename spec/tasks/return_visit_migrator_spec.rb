# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::ReturnVisitMigrator do
  describe '#migrate' do
    let(:factories) { TestFactories.new }
    let(:territory) { Territory.create!(name: 'the-territory') }

    it 'marks as return visits the records allow either can_call or can_ext' do
      can_text = create_attempt('111', false, true)
      can_call = create_attempt('222', true, false)
      do_not_call = create_attempt('333', false, false)
      never_reached = create_attempt('444', nil, nil)

      migrate

      expect(can_text.reload.return_visit).to be true
      expect(can_call.reload.return_visit).to be true
      expect(do_not_call.reload.return_visit).to be false
      expect(never_reached.reload.return_visit).to be nil
    end

    it 'updates phone status with the last call status' do
      phone = Phone.create!(number: '111', territory: territory)

      create_attempt('111', false, true)
      migrate
      expect(phone.reload.return_visit).to be true

      create_attempt('111', false, false)
      migrate
      expect(phone.reload.return_visit).to be false

      create_attempt('111', nil, nil)
      migrate
      expect(phone.reload.return_visit).to be false
    end

    def migrate
      Tasks::ReturnVisitMigrator.new.migrate
    end

    def create_attempt(number, call, text)
      phone = Phone.find_or_create_by!(number: number, territory: territory)
      factories.call_attempts.build(
        phone: phone,
        outcome: 'contacted',
        can_call_again: call,
        can_text: text,
        user: User.new
      ).tap do |attempt|
        attempt.save(validate: false)
      end
    end
  end
end
