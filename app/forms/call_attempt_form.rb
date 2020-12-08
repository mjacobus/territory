# frozen_string_literal: true

class CallAttemptForm
  include ActiveModel::Model

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

  def draft(outcome:, user:)
    @call_attempt.user = user
    @call_attempt.outcome = outcome

    if @call_attempt.errors[:outcome].empty? && @call_attempt.errors[:user].empty?
      return @call_attempt.save(validate: false)
    end

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

  def return_visit=(value)
    @call_attempt.return_visit = value
  end

  def return_visit
    @call_attempt.return_visit
  end

  def reachable_by=(value)
    @call_attempt.reachable_by = value
    @phone.reachable_by = value
  end

  def reachable_by
    @phone.reachable_by
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

  def url
    [@territory, @phone, @call_attempt]
  end

  def contacted?
    @call_attempt.contacted?
  end

  def validate_contacted_fields
    unless contacted?
      return
    end

    unless [true, false].include?(return_visit)
      errors.add(:return_visit, :blank)
    end

    unless notes.present?
      errors.add(:notes, :blank)
    end
  end
end
