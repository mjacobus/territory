# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CallAttemptsController, type: :controller do
  let(:territory) { Territory.create!(name: 'foo', user: current_user) }
  let(:phone) { Phone.create!(number: '222', territory: territory) }
  let(:call_attempt) do
    phone.assign_call_attempt(
      call_attempt_params.merge(
        user: current_user,
        notes: 'original notes'
      )
    )
  end
  let(:call_attempt_params) { { outcome: 'not_home' } }
  let(:params) do
    {
      call_attempt: call_attempt_params,
      territory_id: territory.id,
      phone_id: phone.id
    }
  end

  describe 'POST #create' do
    let(:perform_request) { post :create, params: params }

    it 'creates a new call_attempts' do
      expect { perform_request }.to change(CallAttempt, :count).by(1)
    end

    it 'assigns user to the call attempt' do
      perform_request

      expect(CallAttempt.last.user).to eq(current_user)
    end

    it 'redirects to the phone view' do
      perform_request

      path = territory_phone_path(territory, phone)

      expect(response).to redirect_to(path)
    end
  end

  describe 'POST #quick_create' do
    let(:params) do
      {
        territory_id: territory.id,
        phone_id: phone.id
      }
    end
    let(:perform_request) { post :quick_create, params: params.merge(outcome: 'not_home') }

    it 'quick_create a new call_attempts' do
      expect { perform_request }.to change(CallAttempt, :count).by(1)
    end

    it 'redirects to phone edit form' do
      perform_request

      path = edit_territory_phone_call_attempt_path(
        territory,
        phone,
        CallAttempt.last,
        hide_outcome: true
      )

      expect(response).to redirect_to(path)
    end

    it 'assigns user to the call attempt' do
      perform_request

      expect(CallAttempt.last.user).to eq(current_user)
    end

    it 'redirects to the edit form when phone contacted' do
      post :quick_create, params: params.merge(outcome: 'contacted')

      path = edit_territory_phone_call_attempt_path(
        territory,
        phone,
        CallAttempt.last,
        hide_outcome: true
      )

      expect(response).to redirect_to(path)
    end
  end

  describe 'PUT #update' do
    before do
      call_attempt.user = regular_user
      call_attempt.save!
      call_attempt_params.delete(:outcome)
      call_attempt_params[:notes] = 'updated note'
    end

    let(:current_user) { admin_user }
    let(:params) do
      {
        call_attempt: call_attempt_params.merge(notes: 'updated note'),
        territory_id: territory.id,
        phone_id: phone.id,
        id: call_attempt.id
      }
    end
    let(:perform_request) { put :update, params: params }

    it 'updates data' do
      expect { perform_request }
        .to change { call_attempt.reload.notes }
        .to('updated note')
    end

    it 'redirects to the phone view' do
      perform_request

      path = territory_phone_path(territory, phone)

      expect(response).to redirect_to(path)
    end

    it 'does not update owner' do
      expect { perform_request }
        .not_to(change { call_attempt.reload.user })
    end
  end

  describe 'DELETE #destroy' do
    before do
      call_attempt
    end

    let(:perform_request) { delete :destroy, params: params.merge(id: call_attempt.id) }

    it 'updates data' do
      expect { perform_request }
        .to change { phone.call_attempts.count }.by(-1)
    end

    it 'redirects to the phone view' do
      perform_request

      path = territory_phone_path(territory, phone)

      expect(response).to redirect_to(path)
    end
  end
end
