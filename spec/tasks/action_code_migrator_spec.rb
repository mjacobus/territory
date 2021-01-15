# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::ActionCodeMigrator do
  describe '#migrate' do
    subject(:action) { phone.reload.action.to_s }

    let(:factories) { TestFactories.new }
    let(:phone) { factories.phones.build }

    before do
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(PhoneStatus).to receive(:to_s).and_return(status)
      # rubocop:enable RSpec/AnyInstance

      phone.territory_id = nil
      phone.save(validate: false) # makes sure invalid records can be saved

      described_class.new.migrate
    end

    context 'when status is never_called' do
      let(:status) { 'never_called' }

      it { is_expected.to eq('call') }
    end

    context 'when status is contact_again' do
      let(:status) { 'contact_again' }

      it { is_expected.to eq('return_visit') }
    end

    context 'when status is do_not_contact_again' do
      let(:status) { 'do_not_contact_again' }

      it { is_expected.to eq('forget') }
    end

    context 'when status is unreachable' do
      let(:status) { 'unreachable' }

      it { is_expected.to eq('verify') }
    end

    context 'when status is not_home' do
      let(:status) { 'not_home' }

      it { is_expected.to eq('call') }
    end

    context 'when status is error' do
      let(:status) { 'error' }

      it { is_expected.to eq('error') }
    end
  end
end
