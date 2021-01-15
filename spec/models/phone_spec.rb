# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Phone, type: :model do
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
      phone = described_class.find_by_number('c').next

      expect(phone.number).to eq('d')
    end

    it 'returns first when there is no next' do
      phone = described_class.find_by_number('f').next

      expect(phone.number).to eq('a')
    end

    it 'finds previous and when there is one' do
      phone = described_class.find_by_number('c').previous

      expect(phone.number).to eq('b')
    end

    it 'returns first when there is no previous' do
      phone = described_class.find_by_number('a').previous

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
    let(:factories) { TestFactories.new }
    let(:factory) { factories.call_attempts }

    context 'when transitioning to return_visit to not_home' do
      it 'stays true' do
        phone = factories.phones.create

        factory.create_return_visit(phone: phone)
        factory.create_not_home(phone: phone)
        phone.update_status

        expect(phone.reload.return_visit).to be true
      end
    end

    context 'when transitioning to return_visit to not_home' do
      it 'changes to false' do
        phone = factories.phones.create

        factory.create_return_visit(phone: phone)
        factory.create_do_not_call(phone: phone)
        phone.update_status

        expect(phone.reload.return_visit).to be false
      end
    end

    context 'when transitioning to do_not_visit to not_home' do
      it 'changes to false' do
        phone = factories.phones.create

        factory.create_do_not_call(phone: phone)
        factory.create_not_home(phone: phone)

        phone.update_status

        expect(phone.reload.return_visit).to be false
      end
    end
  end
end
