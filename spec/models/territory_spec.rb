# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Territory do
  subject(:territory) { described_class.new(name: 'T1') }

  it 'is valid when it has a name' do
    expect(territory).to be_valid
  end

  it 'is invalid when name is nil' do
    territory.name = ''

    expect(territory).not_to be_valid
  end

  it 'considers name invalid when it is already taken' do
    described_class.create!(name: 't1')

    expect(territory).not_to be_valid
  end

  it 'sorts territories by name' do
    described_class.create!(name: 'T02')
    described_class.create!(name: 'T01')

    names = described_class.all.map(&:name)

    expect(names).to eq(%w[T01 T02])
  end
end
