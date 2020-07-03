# frozen_string_literal: true

class CallAttemptForm
  include ActiveModel::Model

  def initialize(call_attempt)
    @call_attempt = call_attempt
    @phone = call_attempt.phone
    @territory = @phone.territory
  end

  def persist(attributes)
    self.attributes = attributes
    if valid?
      @phone.save!
      @call_attempt.save!
    end
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
  end

  def reachable_by
    @call_attempt.reachable_by
  end

  def gender=(value)
    @phone.gender = value
    @call_attempt.gender = value
  end

  def gender
    @phone.gender
  end

  def persisted?; end

  def save; end

  def method
    id.present? ? :patch : :post
  end

  def url
    [@territory, @phone, @call_attempt]
  end
end