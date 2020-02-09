# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TerritoriesController, type: :controller do
  describe 'GET #index' do
    let(:territory) { Territory.create!(name: 'foo') }

    it 'assigns @territories' do
      territory

      get :index

      expect(assigns(:territories)).to eq(Territory.all)
    end
  end
end
