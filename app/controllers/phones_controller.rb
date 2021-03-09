# frozen_string_literal: true

class PhonesController < ApplicationController
  def index
    @phones = territory.phones.includes(:call_attempts)
  end

  def show
    @phone_navigator = PhoneNavigator.new(params, scope: territory.phones)
    @phone = PhoneDecorator.new(@phone_navigator.current)

    if params[:navigation_type] == 'random'
      return random_show
    end
  end

  def random_show
    request.query_parameters[:navigation_type] = 'random'
    @phone_navigator = RandomPhoneNavigator.new(current_user, @phone)
    @territory = @phone_navigator.current.territory
    @phone = PhoneDecorator.new(@phone_navigator.current)
    render :show
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
    send_data(
      data,
      content_type: 'text/x-vcard',
      filename: "#{territory.name}-contacts.vcf"
    )
  end

  private

  def phone
    territory.phones.find(params[:id])
  end

  def territory
    @territory ||= current_user.allowed_territories.find(params[:territory_id])
  end
end
