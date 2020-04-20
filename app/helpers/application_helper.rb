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
end
