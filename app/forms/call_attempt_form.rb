# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class CallAttemptForm
  include ActiveModel::Model
  include ApplicationHelper

  validate :validate_contacted_fields

  def initialize(call_attempt)
    @call_attempt = call_attempt
    @phone = call_attempt.phone
    @territory = @phone.territory
  end

  def persist(attributes)
    self.attributes = attributes
    if valid?
      @call_attempt.save!
      @phone.save!
      @phone.update_status
    end
  end

  def destroy
    @phone.update_status
    @call_attempt.destroy
  end

  def draft(outcome:, user:)
    @call_attempt.user = user
    @call_attempt.outcome = outcome

    if @call_attempt.errors[:outcome].empty? && @call_attempt.errors[:user].empty?
      return @call_attempt.save(validate: false)
    end

    @phone.update_status
    @call_attempt.save!
  end

  def model_name
    ActiveModel::Name.new(@call_attempt.class)
  end

  def id
    @call_attempt.id
  end

  def name
    @phone.name
  end

  def name=(value)
    @phone.name = value
    @call_attempt.name = value
  end

  def outcome
    @call_attempt.outcome
  end

  def outcome=(value)
    @call_attempt.outcome = value
  end

  def user
    @call_attempt.user
  end

  def user=(value)
    @call_attempt.user = value
  end

  def notes=(value)
    @call_attempt.notes = value
  end

  def notes
    @call_attempt.notes
  end

  def reachable_by=(value)
    @call_attempt.reachable_by = value
    @phone.reachable_by = value
  end

  def reachable_by
    @phone.reachable_by
  end

  def action_code
    @phone.action_code
  end

  def action_code=(code)
    @phone.action_code = code
  end

  def gender=(value)
    @phone.gender = value
    @call_attempt.gender = value
  end

  def gender
    @phone.gender
  end

  def persisted?
    @phone.persisted? && @call_attempt.persisted?
  end

  def save; end

  def method
    id.present? ? :patch : :post
  end

  def url(query_parameters = {})
    [@territory, @phone, @call_attempt, query_parameters]
  end

  def contacted?
    @call_attempt.contacted?
  end

  def validate_contacted_fields
    unless contacted?
      return
    end

    if notes.blank?
      errors.add(:notes, :blank)
    end
  end

  def action_code_options
    keys = PhoneAction::CODE_MAP.keys
    keys.pop # remove error
    keys.map do |code|
      action = PhoneAction.new(code)
      [action.localized, code]
    end
  end

  def gender_options
    CallAttempt::GENDERS.map do |gender|
      [gender_label(gender), gender]
    end
  end

  # rubocop:disable Metrics/MethodLength
  def allowed_attributes(*_args)
    %i[
      outcome
      name
      user
      phone
      action_code
      notes
      age
      gender
      reachable_by
    ]
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ClassLength
