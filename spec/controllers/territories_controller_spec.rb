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

    context 'when user is logged out' do
      let(:current_user) { nil }

      it 'redirects to /' do
        get :index

        expect(response).to redirect_to('/')
      end
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new

      expect(controller).to render_template('new')
    end

    it 'assigns a new territory' do
      get :new

      expect(assigns(:territory)).to be_a(Territory)
      expect(assigns(:territory)).not_to be_persisted
    end
  end

  describe 'POST #create' do
    context 'when payload is valid' do
      let(:territory_params) { { name: 'T1' } }

      it 'creates a new territory' do
        expect do
          post :create, params: { territory: territory_params }
        end.to change(Territory, :count).by(1)
      end

      it 'redirects to the index page' do
        post :create, params: { territory: territory_params }

        expect(response).to redirect_to('/territories')
      end
    end

    context 'when record is invalid' do
      it 're-renders the form' do
        post :create, params: { territory: { name: '' } }

        expect(controller).to render_template('new')
      end
    end
  end
end
