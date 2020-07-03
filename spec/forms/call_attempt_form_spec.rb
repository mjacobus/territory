# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CallAttemptForm do
  subject(:form) { described_class.new(attempt) }

  let(:phone) { Phone.new }
  let(:attempt) { CallAttempt.new(phone: phone, user: User.new) }

  it 'requires return_visit when person was contacted' do
    form.outcome = 'contacted'
    form.return_visit = ''

    expect(form).not_to be_valid
    expect(form.errors[:return_visit]).not_to be_empty
  end

  it 'requires notes when person was contacted' do
    form.outcome = 'contacted'
    form.notes = ''

    expect(form).not_to be_valid
    expect(form.errors[:notes]).not_to be_empty
  end
end
