# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CallAttemptForm do
  subject(:form) { described_class.new(attempt) }

  let(:phone) { Phone.new }
  let(:attempt) { CallAttempt.new(phone:, user: User.new) }

  it 'requires notes when person was contacted' do
    form.outcome = 'contacted'
    form.notes = ''

    expect(form).not_to be_valid
    expect(form.errors[:notes]).not_to be_empty
  end
end
