# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { User.create!(name: 'admin', master: master, enabled: enabled) }
  let(:enabled) { true }
  let(:master) { true }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe '#index' do
    context 'when user is master' do
      it 'responds with success' do
        get :index

        expect(response).to be_successful
      end

      it 'assigns all users' do
        get :index

        expect(assigns(:users)).to eq(User.all)
      end
    end

    context 'when user is not master' do
      let(:master) { false }

      it 'responds with success' do
        get :index

        expect(response).to redirect_to('/')
      end
    end
  end
end
