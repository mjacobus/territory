# frozen_string_literal: true

module ApplicationHelper
  def outcome_label(outcome)
    {
      not_home: 'Não em Casa',
      contacted: 'Contatado(a)',
      unreachable: 'Número Inválido',
      disconnected: 'Desligado'
    }.fetch(outcome.to_sym)
  end

  def gender_label(gender)
    { male: 'Masculino', female: 'Feminino' }.fetch(gender.to_sym)
  end

  def user_collection_for_select(territory)
    values = User.all.map do |user|
      ["#{user.name} (#{user.email})", user.id]
    end

    if territory.user
      user = territory.user
      values << ["#{user.name} (#{user.email})", user.id]
    end

    values.uniq
  end
end
