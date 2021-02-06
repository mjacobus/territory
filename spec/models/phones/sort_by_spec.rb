# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Phones::SortBy do
  it 'defaults to empty' do
    sort = described_class.new

    expect(sort.to_s).to eq('')
  end

  it 'accepts last_contacted_at.desc' do
    sort = described_class.new('last_contacted_at.desc')

    expect(sort.to_s).to eq('last_contacted_at DESC')
  end

  it 'accepts last_contacted_at.asc' do
    sort = described_class.new('last_contacted_at.asc')

    expect(sort.to_s).to eq('last_contacted_at ASC')
  end

  it 'accepts last_called_at.desc' do
    sort = described_class.new('last_called_at.desc')

    expect(sort.to_s).to eq('last_called_at DESC')
  end

  it 'accepts last_called_at.asc' do
    sort = described_class.new('last_called_at.asc')

    expect(sort.to_s).to eq('last_called_at ASC')
  end

  it 'rejects id.asc' do
    sort = described_class.new('id.asc')

    expect(sort.to_s).to eq('')
  end
end
