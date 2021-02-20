# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:current_user) { admin_user }
  let(:enabled) { true }
  let(:master) { true }
  let(:user) do
    User.create!(
      name: 'admin',
      master: master,
      enabled: enabled
    )
  end

  describe '#index' do
    context 'when user is master' do
      it 'responds with success' do
        get users_path

        expect(response).to be_successful
      end

      it 'assigns all users' do
        get users_path

        expect(assigns(:users)).to eq(User.all)
      end
    end

    context 'when user is not master' do
      let(:current_user) { regular_user }

      it 'redirects to /' do
        get users_path

        expect(response).to redirect_to('/')
      end
    end
  end

  describe '#enable' do
    let(:enabled) { false }

    let(:perform_request) do
      patch enable_user_path(user)
    end

    it 'redirects to /users' do
      perform_request

      expect(response).to redirect_to('/users')
    end

    it 'enables user' do
      expect { perform_request }.to change { user.reload.enabled? }.to(true)
    end
  end

  describe '#disable' do
    let(:perform_request) do
      patch disable_user_path(user)
    end

    it 'redirects to /users' do
      perform_request

      expect(response).to redirect_to('/users')
    end

    it 'disables user' do
      expect { perform_request }.to change { user.reload.enabled? }.to(false)
    end
  end

  describe '#grant_admin' do
    let(:master) { false }
    let(:perform_request) do
      patch grant_admin_user_path(user)
    end

    it 'redirects to /users' do
      perform_request

      expect(response).to redirect_to('/users')
    end

    it 'grants admin privileges to the user' do
      expect { perform_request }.to change { user.reload.master? }.to(true)
    end
  end

  describe '#revoke_admin' do
    let(:perform_request) do
      patch revoke_admin_user_path(user)
    end

    it 'redirects to /users' do
      perform_request

      expect(response).to redirect_to('/users')
    end

    it 'revokes admin rights from user' do
      expect { perform_request }.to change { user.reload.master? }.to(false)
    end
  end
end
