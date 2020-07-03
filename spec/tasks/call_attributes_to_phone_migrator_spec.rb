# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/ExampleLength
RSpec.describe Tasks::CallAttributesToPhoneMigrator do
  describe '#migrate' do
    let(:factories) { TestFactories.new }
    let(:territory) { Territory.create!(name: 'the-territory') }
    let(:migrate) { described_class.new.migrate }

    it 'copies gender and name' do
      create_attempt('111', nil, nil)
      create_attempt('111', 'Foo', 'male')
      create_attempt('111', 'Bar', 'female')
      create_attempt('111', '', 'female')
      create_attempt('222', 'Baz', 'female')
      create_attempt('222', 'Baz', 'female')

      migrate

      phone1 = Phone.find_by_number('111')
      phone2 = Phone.find_by_number('222')

      expect(phone1.name).to eq('Foo, Bar')
      expect(phone2.name).to eq('Baz')
      expect(phone1.gender).to eq('male')
      expect(phone2.gender).to eq('female')
    end

    def create_attempt(number, name, gender)
      phone = Phone.find_or_create_by!(number: number, territory: territory)
      factories.call_attempts.build(
        phone: phone,
        outcome: 'contacted',
        name: name,
        gender: gender,
        user: User.new
      ).tap do |attempt|
        attempt.save(validate: false)
      end
    end
  end
end
# rubocop:enable RSpec/ExampleLength
