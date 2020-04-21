# frozen_string_literal: true

class CallAttemptsController < ApplicationController
  def index
    @call_attempts = phone.call_attempts
  end

  def new
    @call_attempt = phone.call_attempts.build
  end

  def edit
    call_attempt
  end

  def quick_create
    call_attempt = phone.quick_assign_attempt(
      params[:outcome],
      user: current_user
    )

    redirect_to_edit(call_attempt)
  end

  def create
    phone.assign_call_attempt(call_attempt_params)
    redirect_to [territory, phone]
  rescue ActiveRecord::RecordInvalid => exception
    @call_attempt = exception.record
    render :new
  end

  def update
    if call_attempt.update(call_attempt_params)
      return redirect_to([territory, phone])
    end

    render :edit
  end

  def destroy
    call_attempt.destroy
    redirect_to [territory, phone]
  end

  private

  def call_attempt
    @call_attempt ||= phone.call_attempts.find(params[:id])
  end

  def phone
    @phone ||= territory.phones.find(params[:phone_id])
  end

  def territory
    @territory ||= current_user.allowed_territories.find(params[:territory_id])
  end

  def redirect_to_edit(call_attempt)
    url = edit_territory_phone_call_attempt_path(
      territory,
      phone,
      call_attempt,
      hide_outcome: true
    )
    redirect_to(url)
  end

  # rubocop:disable Metrics/MethodLength
  def call_attempt_params
    params.require(:call_attempt).permit(
      :outcome,
      :name,
      :user,
      :phone,
      :notes,
      :age,
      :answered,
      :gender,
      :has_children,
      :can_text,
      :can_call_again,
      :called_annonymously,
      :reachable_by
    ).to_h.merge(user: current_user)
  end
  # rubocop:enable Metrics/MethodLength
end
