# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ApplicationComponent do
  subject(:component) { component_class.new(options) }

  let(:component_class) do
    Class.new(described_class) do
      has :territory
      has :phone, public: true
    end
  end
  let(:options) { { territory: 'the-territory', phone: 'the-phone', something: 'else' } }

  describe '.has' do
    it 'adds a method for a particular propriety, respecting visibility' do
      expect(component.send(:territory)).to eq('the-territory')
      expect(component.phone).to eq('the-phone')
      expect(component).not_to respond_to(:territory)
      expect(component).to respond_to(:phone)
    end

    it 'raises when field is not defined' do
      options.delete(:territory)

      expect do
        component.send(:territory)
      end.to raise_error(ApplicationComponent::MissingArgument, /territory/)
    end
  end
end
