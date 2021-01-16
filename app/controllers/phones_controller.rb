# frozen_string_literal: true

class PhonesController < ApplicationController
  def index
    @phones = territory.phones.includes(:call_attempts)
  end

  def show
    @phone = PhoneDecorator.new(territory.phones.find(params[:id]))
  end

  def create
    territory.create_phones(params[:phone_numbers].split("\n"))
    redirect_to action: :index
  end

  def destroy
    phone.destroy
    redirect_to action: :index
  end

  def vcards
    @phones = territory.phones
    data = render_to_string(template: 'phones/vcards', layout: false)
    send_data(data,
              content_type: 'text/x-vcard',
              filename: "#{territory.name}-contacts.vcf")
    # send_file 'foo', layout: false,
    #   content_type: 'text/x-vcard',
    #   filename: "#{territory.name}-contacts.vcf"
  end

  private

  def phone
    territory.phones.find(params[:id])
  end

  def territory
    @territory ||= current_user.allowed_territories.find(params[:territory_id])
  end
end
