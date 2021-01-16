# frozen_string_literal: true

class PhoneNavigator
  def initialize(params, scope:)
    @params = params
    @scope = apply_params(scope, params)
  end

  def current
    @current ||= @scope.find(current_id)
  end

  def previous
    @previous ||= @scope.find(previous_id)
  end

  def next
    @next ||= @scope.find(next_id)
  end

  def previous_url(url_helper)
    url_helper.url_for(@params.permit!.to_h.merge(id: previous_id, only_path: true))
  end

  def next_url(url_helper)
    url_helper.url_for(@params.permit!.to_h.merge(id: next_id, only_path: true))
  end

  private

  def ids
    @ids ||= ArrayNavigator.new(@scope.pluck(:id), current: current_id)
  end

  def current_id
    @params.fetch(:id).to_i
  end

  def previous_id
    ids.previous
  end

  def next_id
    ids.next
  end

  def apply_params(scope, params)
    where = {}

    if params[:action_code]
      where[:action_code] = params[:action_code]
    end

    if params[:territory_id]
      where[:territory_id] = params[:territory_id]
    end

    or_where = where.merge(id: current_id, action_code: nil).compact
    or_where = scope.where(or_where)
    scope.where(where).or(or_where)
  end
end
