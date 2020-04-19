# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CallAttemptsController, type: :controller do
  let(:territory) { Territory.create!(name: 'foo') }
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

  describe 'PUT #update' do
    before do
      call_attempt_params[:notes] = 'updated note'
    end

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
