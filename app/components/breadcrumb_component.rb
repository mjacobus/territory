# frozen_string_literal: true

class BreadcrumbComponent < ApplicationComponent
  Item = Struct.new(:text, :url, :last)

  def initialize(items = [])
    @items = items
  end

  def each(&block)
    mapped.each(&block)
  end

  attr_reader :items

  def add(text, url = nil)
    @items << [text, url]
    self
  end

  def for_territories
    add('Territórios', urls.territories_path)
  end

  def for_phone(phone)
    for_territories
    add(phone.territory.name)
    add('Telefones', urls.territory_phones_path(phone.territory))
    add(phone.number)
  end

  def for_call_attempts(phone)
    for_territories
    add(phone.territory.name)
    add('Telefones', urls.territory_phones_path(phone.territory))
    add(phone.number, urls.territory_phone_path(phone.territory, phone))
    add('Contatos')
  end

  def for_territory_form(territory)
    for_territories

    if territory.persisted?
      add(territory.name)
      return add('Editar')
    end

    add('Novo')
  end

  def for_phones_index(territory)
    for_territories
    add(territory.name)
    add('Telefones')
  end

  def for_call_attempt_form(call_attempt)
    phone = call_attempt.phone
    territory = phone.territory
    for_territories
    add(territory.name)
    add('Telefones', urls.territory_phones_path(territory))
    add(phone.number, urls.territory_phone_path(territory, phone))
    add('Tentativas de Contato', urls.territory_phone_path(territory, phone))
    add('Alterar')
  end

  private

  def mapped
    items.map.with_index do |item, index|
      last = (index + 1) == items.length
      Item.new(item[0], item[1], last)
    end
  end
end
