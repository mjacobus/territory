# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Phone, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  let(:phone) { described_class.new(number: 'some-number', territory: territory) }
  let(:territory) { Territory.new(name: 'T1') }
  let(:user) { User.create!(name: 'name') }

  it 'belongs to territory' do
    expect(phone.territory).to eq(territory)
  end

  describe '#action' do
    it 'defaults to zero' do
      expect(phone.action.code).to eq(0)
    end
  end

  context 'when quering for previous' do
    before do
      territory.save!

      %w[a b c d e f].shuffle.each do |number|
        described_class.create!(number: number, territory: territory)
      end
    end

    it 'finds next and when there is one' do
      phone = described_class.find_by(number: 'c').next

      expect(phone.number).to eq('d')
    end

    it 'returns first when there is no next' do
      phone = described_class.find_by(number: 'f').next

      expect(phone.number).to eq('a')
    end

    it 'finds previous and when there is one' do
      phone = described_class.find_by(number: 'c').previous

      expect(phone.number).to eq('b')
    end

    it 'returns first when there is no previous' do
      phone = described_class.find_by(number: 'a').previous

      expect(phone.number).to eq('f')
    end
  end

  describe '#assign_call_attempt' do
    before do
      phone.save!
    end

    let(:attributes) { { outcome: 'not_home', user: user } }
    let(:assign) { phone.assign_call_attempt(attributes) }

    it 'saves the call attempt' do
      expect { assign }.to change { phone.call_attempts.count }.by(1)
    end
  end

  describe '#update_status' do
    before do
      phone.save!
      CallAttemptForm.new(phone.call_attempts.build).draft(outcome: 'contacted', user: User.last)
    end

    it 'updates last_contacted_at' do
      freeze_time do
        phone.update_status

        expect(phone.reload.last_contacted_at.to_i).to eq(Time.now.to_i)
      end
    end

    it 'updates last_called_at' do
      freeze_time do
        phone.update_status

        expect(phone.reload.last_called_at.to_i).to eq(Time.now.to_i)
      end
    end

    it 'updates last_contacted_at to nil when there are no records' do
      freeze_time do
        phone.update_status
        phone.call_attempts.clear
        phone.update_status

        expect(phone.reload.last_contacted_at).to be_nil
      end
    end

    it 'updates last_called_at to nil when there are no records' do
      freeze_time do
        phone.update_status
        phone.call_attempts.clear
        phone.update_status

        expect(phone.reload.last_called_at).to be_nil
      end
    end
  end
end
