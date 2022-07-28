# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhoneNavigator do
  subject(:navigator) { described_class.new(params, scope: Phone.all) }

  let(:factories) { TestFactories.new }
  let(:territory) { factories.territories.create }
  let(:phones) { factories.phones }
  let(:current) { phones.create(number: '13', territory:) }
  let(:params) do
    {
      territory_id: territory.id,
      id: current.id.to_s,
      action_code: 0
    }
  end

  before do
    phones.create(number: '10', territory:)
    phones.create(number: '11', territory:)
    phones.create(number: '12', territory:, action_code: 2)
    current
    phones.create(number: '14') # other territory
    phones.create(number: '15', territory:)
    phones.create(number: '16', territory:)
    phones.create # different territory
  end

  context 'when current has the same state' do
    it 'properly calculates current' do
      expect(navigator.current.number).to eq('13')
    end

    it 'properly calculates previous' do
      expect(navigator.previous.number).to eq('11')
    end

    it 'properly calculates next' do
      expect(navigator.next.number).to eq('15')
    end
  end

  context 'when current has the different state' do
    before do
      current.update_attribute(:action_code, 2)
    end

    it 'properly calculates current' do
      expect(navigator.current.number).to eq('13')
    end

    it 'properly calculates previous' do
      expect(navigator.previous.number).to eq('11')
    end

    it 'properly calculates next' do
      expect(navigator.next.number).to eq('15')
    end
  end

  context 'when current does not belong to the scope' do
    before do
      current.update_attribute(:territory_id, Territory.unscoped.order(:id).last.id)
    end

    it 'raises error' do
      expect { navigator.current }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
