# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Phone, type: :model do
  let(:phone) { described_class.new(number: 'some-number', territory: territory) }
  let(:territory) { Territory.new }

  it 'belongs to territory' do
    expect(phone.territory).to eq(territory)
  end
end
