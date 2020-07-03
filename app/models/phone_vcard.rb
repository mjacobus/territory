# frozen_string_literal: true

class PhoneVcard
  def initialize(phone, format = '')
    @phone = PhoneDecorator.new(phone)
    @format = format
  end

  def treated_as
    # Mr.
    ''
  end

  def org
    ''
  end

  def title
    ''
  end

  def url_path
    "/territories/#{@phone.territory_id}/phones/#{@phone.to_param}"
  end

  def first_name
    @phone.contact_name
  end

  def last_name
    ''
  end

  def full_name
    "#{prefix} #{first_name} #{@phone.casted_number.sanitized}"
  end

  def prefix
    I18n.t('app.vcard.name_prefix')
  end

  def formatted_phone
    @phone.casted_number.sanitized
  end

  def note
    I18n.t('app.vcard.notes', notes: @phone.notes.join('. ').tr("\n", ' '))
  end

  def email; end

  def revision
    Time.now.to_i
  end

  def uid
    "kt-#{@phone.id}"
  end
end
