# frozen_string_literal: true

class PhoneDecorator
  delegate(*Phone.column_names, to: :@phone)
  delegate :to_param,
           :id,
           :call_attempts,
           :previous,
           :carrier_variations,
           :casted_number,
           :territory,
           :next,
           :name,
           :action,
           to: :@phone

  def initialize(phone)
    @phone = phone
  end

  def contact_name
    name
  end

  def carrier_variations
    {
      'Vivo/Telefônica/GVT' => casted_number.with_prefix('015'),
      'TIM' => casted_number.with_prefix('041'),
      'Oi' => casted_number.with_prefix('014'),
      'Claro/Net' => casted_number.with_prefix('021')
    }
  end

  def contacted?
    outcomes.include?('contacted')
  end

  def notes
    @phone.call_attempts.pluck(:notes).compact
  end

  def contact?
    true
  end

  def to_s
    @phone.to_s
  end

  def outcomes
    @outcomes ||= pluck(:outcome)
  end

  private

  def pluck(field)
    @plucked ||= @phone.call_attempts.pluck(*fields_to_pluck)

    @plucked.map do |fields|
      fields[fields_to_pluck.index(field)]
    end
  end

  def fields_to_pluck
    %i[name outcome]
  end
end
