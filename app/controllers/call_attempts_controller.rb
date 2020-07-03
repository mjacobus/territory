# frozen_string_literal: true

class CallAttemptsController < ApplicationController
  def index
    @call_attempts = phone.call_attempts
  end

  def new
    form
  end

  def edit
    form
  end

  def quick_create
    form.draft(outcome: params[:outcome], user: current_user)
    url = [:edit, form.url, hide_outcome: true].flatten
    redirect_to(url)
  end

  def create
    form.persist(call_attempt_params)
    redirect_to [territory, phone]
  rescue ActiveRecord::RecordInvalid => exception
    @call_attempt = exception.record
    render :new
  end

  def update
    if form.persist(call_attempt_params.except(:user))
      return redirect_to([territory, phone])
    end

    render :edit
  end

  def destroy
    call_attempt.destroy
    redirect_to [territory, phone]
  end

  private

  def form
    @form ||= CallAttemptForm.new(
      params[:id] ? call_attempt : phone.call_attempts.build
    )
  end

  def call_attempt
    @call_attempt ||= phone.call_attempts.find(params[:id])
  end

  def phone
    @phone ||= territory.phones.find(params[:phone_id])
  end

  def territory
    @territory ||= current_user.allowed_territories.find(params[:territory_id])
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
      :return_visit,
      :called_annonymously,
      :reachable_by
    ).to_h.merge(user: current_user)
  end
  # rubocop:enable Metrics/MethodLength
end
